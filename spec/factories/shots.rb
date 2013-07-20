# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :shot do
    association :game
    association :player
    is_hit false
    cup_position 1
  end
end
