require 'spec_helper'

describe LeaguesController do
  describe "GET #index" do
    it "populates an array of leagues" do
      leagues = []
      5.times { leagues << create(:league) }
      get :index
      assigns(:leagues).should eq(leagues.reverse)
    end

    it "renders the :index view" do
      get :index
      response.should render_template :index
    end

    it "builds a new player" do
      get :index
      assigns(:player).should be_new_record
    end
  end

end
