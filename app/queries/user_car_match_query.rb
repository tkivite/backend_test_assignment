class UserCarMatchQuery
  def initialize(relation = Car.all,user)
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

  def user_recomendation(size)
    @relation.where(:id => @user.user_car_recomendations.order(rank_score: :desc).limit(size).map(&:car_id))
  end

  def no_match
    @relation.where.not(:brand => @user.preferred_brands).where.not(:price => @user.preferred_price_range)
  end
end
