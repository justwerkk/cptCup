FactoryGirl.define do
  factory :game do
    association :player_one, factory: :player
    association :player_two, factory: :player
    association :player_three, factory: :player
    association :player_four, factory: :player
    association :league
    sequence(:created_at) { |n| Date.new(2012, 1, 1) + n }

    factory :completed_game do
      cups_left 1
      is_team_one_victory true
    end
  end
end
