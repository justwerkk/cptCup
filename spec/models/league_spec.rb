require 'spec_helper'

describe League do
  let(:league) { create(:league) }

  it "can't be deleted if it has games" do
    league.games << create(:game, league: league)

    expect {league.destroy}.to raise_exception(ActiveRecord::DeleteRestrictionError)
  end

  it "can be deleted if there are no games" do
    league.destroy

    league.should be_destroyed
  end

  it "can't be deleted if it is completed" do
    league.update_attributes(end_date: Date.today)

    league.destroy
    league.should_not be_destroyed

    league.should have(1).error
  end
end
