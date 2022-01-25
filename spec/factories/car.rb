FactoryGirl.define do
  factory :car do
    sequence(:model, 'a') { |n| "Car" + n }
    sequence(:price) { |n|  n*1000 }    
    brand
  end
end
