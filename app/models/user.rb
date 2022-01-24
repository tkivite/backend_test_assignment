class User < ApplicationRecord
  has_many :user_car_recomendations
  has_many :user_preferred_brands, dependent: :destroy
  has_many :preferred_brands, through: :user_preferred_brands, source: :brand
  has_many :recommendations, through: :user_car_recomendations, source: :car

  #scope :user_perfect_match, ->(car) { where(car.user_label(self) == "perfect_match") }
  #scope :user_preferred_brand, ->(car) { joins(:car).where(user.preferred_brands.include?(car.brand) == true) }

  #validations
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }

  def car_selection

    # On top it should be cars with perfect_match label. This cars have match with user preferred car brands ( user.preferred_brands.include?(car.brand) == true) and with preferred price (user.preferred_price_range.include?(car.price) == true).
    # Then we should have good_match offers. These offers have the only user preferred car brands (user.preferred_brands.include?(car.brand) == true).
    # Then goes top 5 cars suggested by external recommendation service API (they can also be matched as perfect and good matches).
    # Then goes all other cars sorted by price (ASC).
  end
end
