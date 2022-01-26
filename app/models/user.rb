class User < ApplicationRecord
  has_many :user_car_recomendations
  has_many :user_preferred_brands, dependent: :destroy
  has_many :preferred_brands, through: :user_preferred_brands, source: :brand

  #validations
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }

  def user_car_label(car)
    return "perfect_match" if self.preferred_brands.include?(car.brand) && (self.preferred_price_range.include?(car.price))
    return "good_match" if (self.preferred_brands.include?(car.brand))
  end

  def user_car_rank(car)
    self.user_car_recomendations.where(car_id: car.id).first.try(:rank_score)
  end
end
