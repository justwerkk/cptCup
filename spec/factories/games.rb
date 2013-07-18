FactoryGirl.define do
  factory :game do
    association :winner_one, factory: :player
    association :winner_two, factory: :player
    association :loser_one, factory: :player
    association :loser_two, factory: :player
    cups_left 1
    association :league
    sequence(:created_at) { |n| Date.new(2012, 1, 1) + n }
  end
end
