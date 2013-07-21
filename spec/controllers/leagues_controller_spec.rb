require 'spec_helper'

describe LeaguesController do
  describe "GET #index" do
    it "should populate an array of leagues" do
      leagues = []
      5.times { leagues << create(:league) }
      get :index
      assigns(:leagues).should eq(leagues.reverse)
    end

    it "should render the :index view" do
      get :index
      response.should render_template :index
    end

    it "should build a new player" do
      get :index
      assigns(:player).should be_new_record
    end
  end

  describe "GET #show" do
    before(:each) do
      @league = create(:league)
      @p1 = create(:player)
      @p2 = create(:player)
      @p3 = create(:player)
      @p4 = create(:player)

      10.times { create(:completed_game, player_one: @p1, player_two: @p2, player_three: @p3, player_four: @p4, league: @league) }

      get :show, id: @league.id
    end

    it "should assign the selected league" do
      assigns(:league).should == @league
    end

    it "should include the number of games in this league" do
      assigns(:num_games).should == 10
    end

    it "should create a players hash used for stats" do
      assigns(:players_hash).keys.sort.should == [@p1.id, @p2.id, @p3.id, @p4.id]
      assigns(:players_hash).values.include?(@p1.name).should be_true
      assigns(:players_hash).values.include?(@p2.name).should be_true
      assigns(:players_hash).values.include?(@p3.name).should be_true
      assigns(:players_hash).values.include?(@p4.name).should be_true
    end

    it "should exclude players that arent in the leagure from player hash" do
      create(:player)
      assigns(:players_hash).should have(4).items
    end

    it "should create a players rankings hash used for stats" do
      assigns(:player_rankings).keys.sort.should == [@p1.id, @p2.id, @p3.id, @p4.id]
    end

    it "should create a game hash used for stats" do
      assigns(:game_hash)[@p1.id].should == [[@p3.id, [10,0]], [@p4.id, [10,0]]]
      assigns(:game_hash)[@p2.id].should == [[@p3.id, [10,0]], [@p4.id, [10,0]]]
      assigns(:game_hash)[@p3.id].should == [[@p1.id, [0,10]], [@p2.id, [0,10]]]
      assigns(:game_hash)[@p4.id].should == [[@p1.id, [0,10]], [@p2.id, [0,10]]]
    end

    it "should exclude players that arent in the league from the game hash" do
      create(:player)
      assigns(:game_hash).should have(4).items
    end
  end

end
