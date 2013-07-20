require 'spec_helper'

describe Shot do
  it "cannot be the same cup on the same team twice" do
    p1 = create(:player)
    p2 = create(:player)
    p3 = create(:player)
    p4 = create(:player)

    g = create(:game, player_one: p1, player_two: p2, player_three: p3, player_four: p4)
    create(:shot, game: g, player: p1, cup_position: 1)
    shot = build(:shot, game: g, player: p1, cup_position: 1)
    shot.should_not be_valid
    shot.should have(1).error_on(:cup_position)
  end
end
