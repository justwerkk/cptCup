require 'spec_helper'

describe Game do
  before(:all) do
    @p1 = create(:player)
    @p2 = create(:player)
    @p3 = create(:player)
    @p4 = create(:player)

    @starting_score = 1200
    @k_factor = 16
    @multiplier = 400.0
  end

  after(:all) do
    Player.delete_all
  end

  it "has a valid factory" do
    build(:game).should be_valid
  end

  it "should be invalid if a player appears twice" do
    g = build(:game, player_one: @p1, player_two: @p1, player_three: @p2, player_four: @p2)
    g.should_not be_valid
    g.should have(1).error_on(:base)

    g = build(:game, player_one: @p1, player_two: @p2, player_three: @p2, player_four: @p3)
    g.should_not be_valid
    g.should have(1).error_on(:base)

    g = build(:game, player_one: @p1, player_two: @p2, player_three: @p3, player_four: @p3)
    g.should_not be_valid
    g.should have(1).error_on(:base)

    g = build(:game, player_one: @p1, player_two: @p2, player_three: @p3, player_four: @p1)
    g.should_not be_valid
    g.should have(1).error_on(:base)
  end

  context "when calculating player scores" do
    it "uses elo algorithm" do
      games = []
      games << build(:completed_game, player_one: @p1, player_two: @p2, player_three: @p3, player_four: @p4)
      games << build(:completed_game, player_one: @p1, player_two: @p3, player_three: @p2, player_four: @p4)
      games << build(:completed_game, player_one: @p3, player_two: @p4, player_three: @p2, player_four: @p1)
      games << build(:completed_game, player_one: @p1, player_two: @p4, player_three: @p2, player_four: @p3)

      rankings = Game.calculate_rankings(games, @starting_score, @k_factor, @multiplier)
      rankings[@p1.id].should be_within(0.01).of(1215.26)
      rankings[@p2.id].should be_within(0.01).of(1183.26)
      rankings[@p3.id].should be_within(0.01).of(1200.73)
      rankings[@p4.id].should be_within(0.01).of(1200.73)
    end


    it "ignores incomplete games" do
      games = []
      games << build(:completed_game, player_one: @p1, player_two: @p2, player_three: @p3, player_four: @p4)
      games << build(:game, player_one: @p1, player_two: @p2, player_three: @p3, player_four: @p4)
      games << build(:completed_game, player_one: @p1, player_two: @p3, player_three: @p2, player_four: @p4)
      games << build(:completed_game, player_one: @p3, player_two: @p4, player_three: @p2, player_four: @p1)
      games << build(:completed_game, player_one: @p1, player_two: @p4, player_three: @p2, player_four: @p3)

      rankings = Game.calculate_rankings(games, @starting_score, @k_factor, @multiplier)
      rankings[@p1.id].should be_within(0.01).of(1215.26)
      rankings[@p2.id].should be_within(0.01).of(1183.26)
      rankings[@p3.id].should be_within(0.01).of(1200.73)
      rankings[@p4.id].should be_within(0.01).of(1200.73)
    end


    it "supports team 2 winning" do
      games = []
      games << build(:completed_game, player_one: @p1, player_two: @p2, player_three: @p3, player_four: @p4, is_team_one_victory: false)
      games << build(:completed_game, player_one: @p1, player_two: @p3, player_three: @p2, player_four: @p4, is_team_one_victory: false)
      games << build(:completed_game, player_one: @p3, player_two: @p4, player_three: @p2, player_four: @p1, is_team_one_victory: false)
      games << build(:completed_game, player_one: @p1, player_two: @p4, player_three: @p2, player_four: @p3, is_team_one_victory: false)

      rankings = Game.calculate_rankings(games, @starting_score, @k_factor, @multiplier)
      rankings[@p2.id].should be_within(0.01).of(1216.73)
      rankings[@p4.id].should be_within(0.01).of(1199.26)
      rankings[@p3.id].should be_within(0.01).of(1199.26)
      rankings[@p1.id].should be_within(0.01).of(1184.73)
    end

    it "is zero sum" do
      games = []
      15.times do
        players = [@p1, @p2, @p3, @p4].shuffle
        games << build(:completed_game, player_one: players.pop, player_two: players.pop, player_three: players.pop, player_four: players.pop)
      end

      rankings = Game.calculate_rankings(games, @starting_score, @k_factor, @multiplier)
      rankings.values.reduce(:+).should be_within(0.001).of(@starting_score*4)
    end

    it "rewards scores in a logarithmic curve" do
      games = []
      p1_scores = [Game.calculate_rankings(games, @starting_score, @k_factor, @multiplier)[@p1.id]]

      20.times do
        games << build(:completed_game, player_one: @p1, player_two: @p2, player_three: @p3, player_four: @p4)
        p1_scores << Game.calculate_rankings(games, @starting_score, @k_factor, @multiplier)[@p1.id]
      end

      p1_score_diffs = []
      (0...p1_scores.length-1).each {|i| p1_score_diffs[i] = p1_scores[i+1] - p1_scores[i]}

      p1_score_diffs.should == p1_score_diffs.sort.reverse
    end

    it "rewards underdogs more than the favorites" do
      games = []

      5.times do
        games << build(:completed_game, player_one: @p1, player_two: @p2, player_three: @p3, player_four: @p4)
      end

      p1_score = Game.calculate_rankings(games, @starting_score, @k_factor, @multiplier)[@p1.id]
      p3_score = Game.calculate_rankings(games, @starting_score, @k_factor, @multiplier)[@p3.id]

      games << build(:completed_game, player_one: @p1, player_two: @p2, player_three: @p3, player_four: @p4)

      p1_score_gained = Game.calculate_rankings(games, @starting_score, @k_factor, @multiplier)[@p1.id] - p1_score

      games.pop
      games << build(:completed_game, player_one: @p3, player_two: @p4, player_three: @p1, player_four: @p2)
      p3_score_gained = Game.calculate_rankings(games, @starting_score, @k_factor, @multiplier)[@p3.id] - p3_score

      (p3_score_gained - p1_score_gained).should > 0
    end
  end

  context "when given a new game" do
    before(:each) do
      @league = create(:league)
      create(:completed_game, player_one: @p1, player_two: @p3, player_three: @p2, player_four: @p4, league: @league)
      create(:completed_game, player_one: @p1, player_two: @p2, player_three: @p3, player_four: @p4, league: @league)
      create(:completed_game, player_one: @p3, player_two: @p4, player_three: @p2, player_four: @p1, league: @league)
      create(:completed_game, player_one: @p1, player_two: @p4, player_three: @p2, player_four: @p3, league: @league)
    end

    it "calculates expected outcome" do
      match_up = build(:completed_game, player_one: @p1, player_two: @p4, player_three: @p2, player_four: @p3, league: @league)
      team_1, team_2 = match_up.expected_outcome(@starting_score, @k_factor, @multiplier)
      team_1.should be_within(0.0001).of(0.5459)
      team_2.should be_within(0.0001).of(0.4540)
    end

    it "calculates total winner score" do
      match_up = build(:completed_game, player_one: @p1, player_two: @p4, player_three: @p2, player_four: @p3, league: @league)
      winner_score = match_up.total_winner_score(@starting_score, @k_factor, @multiplier)
      winner_score.should be_within(0.01).of(2416.0)
    end

    it "calculates total loser score" do
      match_up = build(:completed_game, player_one: @p1, player_two: @p4, player_three: @p2, player_four: @p3, league: @league)
      loser_score = match_up.total_loser_score(@starting_score, @k_factor, @multiplier)
      loser_score.should be_within(0.01).of(2384.0)
    end
  end

end
