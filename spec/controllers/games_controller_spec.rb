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

  describe "POST create" do
    context "with valid params" do
      it "should redirect to games/shot_tracker if in interactive mode" do
        post :create, {:game => {player_one_id: @p1.id, player_two_id: @p2.id, player_three_id: @p3.id, player_four_id: @p4.id}, league_id: @league.id, mode: 'interactive'}
        response.should redirect_to(shot_tracker_league_game_url(@league, assigns(:game)))
      end

      it "should redirect to league index if regular mode" do
        post :create, {:game => {player_one_id: @p1.id, player_two_id: @p2.id, player_three_id: @p3.id, player_four_id: @p4.id}, league_id: @league.id, mode: 'completed'}
        response.should redirect_to(@league)
      end
    end
  end
end
