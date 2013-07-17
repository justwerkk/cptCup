require 'spec_helper'

describe LeaguesController do
  describe "GET #index" do
    it "populates an array of leagues" do
      leagues = []
      5.times { leagues << create(:league) }
      get :index
      assigns(:leagues).should eq(leagues.reverse)
    end

    it "renders the :index view"
    it "builds a new player"
  end

end
