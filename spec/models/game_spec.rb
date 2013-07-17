require 'spec_helper'

describe Game do
  before(:all) do
    @p1 = create(:player)
    @p2 = create(:player)
    @p3 = create(:player)
    @p4 = create(:player)
  end

  after(:all) do
    Player.delete_all
  end

  it "has a valid factory" do
    build(:game).should be_valid
  end

  it "should be invalid if a player appears twice" do
    g = build(:game, winner_one: @p1, winner_two: @p1, loser_one: @p2, loser_two: @p2)
    g.should_not be_valid
    g.should have(1).error_on(:base)

    g = build(:game, winner_one: @p1, winner_two: @p2, loser_one: @p2, loser_two: @p3)
    g.should_not be_valid
    g.should have(1).error_on(:base)

    g = build(:game, winner_one: @p1, winner_two: @p2, loser_one: @p3, loser_two: @p3)
    g.should_not be_valid
    g.should have(1).error_on(:base)

    g = build(:game, winner_one: @p1, winner_two: @p2, loser_one: @p3, loser_two: @p1)
    g.should_not be_valid
    g.should have(1).error_on(:base)
  end

  context "when given a list of games" do
    it "calculates players scores" do
      games = []
      games << build(:game, winner_one: @p1, winner_two: @p2, loser_one: @p3, loser_two: @p4)
      games << build(:game, winner_one: @p1, winner_two: @p3, loser_one: @p2, loser_two: @p4)
      games << build(:game, winner_one: @p3, winner_two: @p4, loser_one: @p2, loser_two: @p1)
      games << build(:game, winner_one: @p1, winner_two: @p4, loser_one: @p2, loser_two: @p3)

      rankings = Game.calculate_rankings(games, 1200, 16, 400.0)
      rankings[@p1.id].should be_within(0.01).of(1215.26)
      rankings[@p2.id].should be_within(0.01).of(1183.26)
      rankings[@p3.id].should be_within(0.01).of(1200.73)
      rankings[@p4.id].should be_within(0.01).of(1200.73)
    end

    it "rewards scores in a logarithmic curve" do
      games = []
      p1_scores = [Game.calculate_rankings(games, 1200, 16, 400.0)[@p1.id]]

      20.times do
	games << build(:game, winner_one: @p1, winner_two: @p2, loser_one: @p3, loser_two: @p4)
	p1_scores << Game.calculate_rankings(games, 1200, 16, 400.0)[@p1.id]
      end

      p1_score_diffs = []
      (0...p1_scores.length-1).each {|i| p1_score_diffs[i] = p1_scores[i+1] - p1_scores[i]}

      p1_score_diffs.should == p1_score_diffs.sort.reverse
    end

    it "rewards underdogs more than the favorites"

    pending "it calculates the total winner score"
    pending "it calculates the total loser score"
    pending "it calculates rankings"
  end
end
