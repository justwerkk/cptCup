require 'spec_helper'

describe Player do
  let(:player){ create(:player) }

  it "cant be destroyed if it has played games" do
    create(:game, winner_one: player)

    expect {player.destroy}.to raise_exception(ActiveRecord::DeleteRestrictionError)
  end

  it "can be destroyed if it hasnt played games" do
    player.destroy
    player.should be_destroyed
  end
end
