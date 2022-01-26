class Car < ApplicationRecord
  belongs_to :brand
  # Scope for query filter
  scope :filter_with_brand, ->(query_value) { joins(:brand).where(["name LIKE ?", "%#{query_value}%"]) }
  scope :filter_with_price_min, ->(price_min) { where(["price  > ?", price_min]) }
  scope :filter_with_price_max, ->(price_max) { where(["price  < ?", price_max]) }

  #validations
  validates :model, presence: true, uniqueness: { scope: [:brand_id], case_sensitive: false }
  
end
