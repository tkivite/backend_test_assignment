FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "test#{n}@test.com" }    
    preferred_price_range 10000..20000
  end
end
