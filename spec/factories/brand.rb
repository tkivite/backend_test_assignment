FactoryGirl.define do
  factory :brand do
    sequence(:name, 'b') { |n| "Brand" + n }
  end
end
