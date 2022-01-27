class UserCarMatchQuery
  def initialize(relation = Car.all, user)
    @relation = relation
    @user = user
  end

  def perfect_match
    @relation.where(:brand => @user.preferred_brands).where(:price => @user.preferred_price_range)
  end

  def good_match
    @relation.where(:brand => @user.preferred_brands).where.not(:price => @user.preferred_price_range)
  end

  def brand_match
    @relation.where(:brand => @user.preferred_brands)
  end

  def price_match
    @relation.where(:price => @user.preferred_price_range)
  end

  def user_recomendation
    size = ENV["CAR_RECOMENDATION_FETCH_SIZE"].to_i || 5
    @relation.where(:id => @user.user_car_recomendations.order(rank_score: :desc).limit(size).map(&:car_id))
  end

  def no_match
    @relation.where.not(:brand => @user.preferred_brands).where.not(:price => @user.preferred_price_range).order(price: :desc)
  end

  #  def order_by_field(field,direction)
  #   @relation.order("#{field} #{direction}")
  #  end

end
