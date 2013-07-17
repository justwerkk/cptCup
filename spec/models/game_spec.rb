require 'spec_helper'

describe Game do
  it "can't include the same player twice" do
    p1 = create(:player)
    p2 = create(:player)
    p3 = create(:player)

    g = build(:game, winner_one: p1, winner_two: p1, loser_one: p2, loser_two: p2)
    g.should_not be_valid
    g.should have(1).error_on(:base)

    g = build(:game, winner_one: p1, winner_two: p2, loser_one: p2, loser_two: p3)
    g.should_not be_valid
    g.should have(1).error_on(:base)

    g = build(:game, winner_one: p1, winner_two: p2, loser_one: p3, loser_two: p3)
    g.should_not be_valid
    g.should have(1).error_on(:base)

    g = build(:game, winner_one: p1, winner_two: p2, loser_one: p3, loser_two: p1)
    g.should_not be_valid
    g.should have(1).error_on(:base)
  end

  pending "it calculates rankings of players"
  pending "it calculates the total winner score"
  pending "it calculates the total loser score"
  pending "it calculates rankings"
end
