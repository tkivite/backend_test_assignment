FactoryGirl.define do
    factory :user_car_recomendation do     
      sequence(:rank_score) { |n|  n/1000 }    
      user
      car
    end
  end
