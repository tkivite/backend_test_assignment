class User < ApplicationRecord
  has_many :user_car_recomendations
  has_many :user_preferred_brands, dependent: :destroy
  has_many :preferred_brands, through: :user_preferred_brands, source: :brand
  has_many :recommendations, through: :user_car_recomendations, source: :car

  #validations
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }
end
