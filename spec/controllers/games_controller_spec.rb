require 'spec_helper'

describe GamesController do
  before(:each) do
    @p1 = create(:player)
    @p2 = create(:player)
    @p3 = create(:player)
    @p4 = create(:player)

    @league = create(:league)
    10.times { create(:game, player_one: @p1, player_two: @p2, player_three: @p3, player_four: @p4, league: @league) }
  end

  let(:league) { create(:league) }

  describe "GET #index" do
    it "should set current league" do
      get :index, league_id: @league.id
      assigns(:league).should == @league
    end

    it "should assign an array of all games for this league" do
      get :index, league_id: @league.id
      assigns(:games).should have(10).items
    end

    it "should exclude games from other leagues in games array" do
      create(:game, player_one: @p1, player_two: @p2, player_three: @p3, player_four: @p4, league: league)
      get :index, league_id: @league.id
      assigns(:games).should have(10).items
    end

    it "should order games in descending order" do
      get :index, league_id: @league.id
      assigns(:games).sort {|a, b| a.created_at <=> b.created_at}.reverse.should == assigns(:games)
    end
  end
end
