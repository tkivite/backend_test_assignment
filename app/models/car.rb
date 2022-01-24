class Car < ApplicationRecord
  belongs_to :brand
  # Scope for query filter
  scope :filter_with_brand, ->(query_value) { joins(:brand).where(["name LIKE ?", "%#{query_value}%"]) }
  scope :filter_with_price_min, ->(price_min) { where(["price  > ?", price_min]) }
  scope :filter_with_price_max, ->(price_max) { where(["price  < ?", price_max]) }
  scope :weighted_car_search, ->(user) { weighted_search(user) }
  scope :user_ai_recommendations, ->(user) { user_ai_recommendation(user) }
  scope :user_unranked_cars, ->(user) { unranked(user) }

  #validations
  validates :model, presence: true, uniqueness: { scope: [:brand_id], case_sensitive: false }

  def user_label(user)
    return "perfect_match" if user.preferred_brands.include?(self.brand) && (user.preferred_price_range.include?(self.price)) if !user.nil?
    return "good_match" if (user.preferred_brands.include?(self.brand)) if !user.nil?
  end

  def user_rank_score(user)
    user.user_car_recomendations.where(car_id: id).first.try(:rank_score) if !user.nil?
  end

  def self.weighted_search(user)
    self.select("cars.*,case 
    when 
     cars.brand_id in (select brand_id from user_preferred_brands where user_id = #{user.id}) 
     AND cars.price <    (select upper(preferred_price_range) from users where id = #{user.id}) 
     and cars.price >    (select lower(preferred_price_range) from users where id = #{user.id}) then 4
     when 
       cars.brand_id in (select brand_id from user_preferred_brands where user_id = #{user.id}) 
       AND (cars.price >(select upper(preferred_price_range) from users where id = #{user.id}) 
       or cars.price <  (select lower(preferred_price_range) from users where id = #{user.id})) then 3
     when  
       cars.id in (select car_id from user_car_recomendations where user_id = #{user.id}) then 2
     else 1 end as weight")
      .where("cars.brand_id in (select brand_id from user_preferred_brands where user_id = #{user.id})")
      .order("weight desc")
  end

  def self.user_ai_recommendation(user)
    car_ids = []
    user.user_car_recomendations.order(rank_score: :desc).limit(5).each { |rec| car_ids << rec.car_id }
    Car.where(id: car_ids)
  end
  def self.unranked(user)
    self.where(" 
     cars.brand_id not in (select brand_id from user_preferred_brands where user_id = #{user.id}) 
     AND (cars.price >    (select upper(preferred_price_range) from users where id = #{user.id}) 
     OR  cars.price <    (select lower(preferred_price_range) from users where id = #{user.id}))
     AND cars.id not in (select car_id from user_car_recomendations where user_id = #{user.id})").order(price: :asc)
  end
end
