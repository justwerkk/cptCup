FactoryGirl.define do
  factory :league do
    sequence(:name) {|n| "League #{n}" }
  end
end
