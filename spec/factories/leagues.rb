FactoryGirl.define do
  factory :league do
    sequence(:name) {|n| "League #{n}" }
    sequence(:start_date) { |n| Date.new(2012, 1, 1) + n }
  end
end
