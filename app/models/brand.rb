class Brand < ApplicationRecord
  #associations
  has_many :cars, dependent: :destroy
  scope :with_filter, -> (query_value) { where(['name LIKE ?', "%#{query_value}%"]) }
  validates :name, presence: true, uniqueness: {case_sensitive: false}
end
