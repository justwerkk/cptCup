class CreateFirstLeague < ActiveRecord::Migration
  def up
    first_league = League.create(name: "Canuto Cup Season 1",
                                 start_date: Date.new(2012, 10, 6))

    Game.all.each {|game| game.update_attribute(:league_id, first_league.id)}
  end

  def down
    League.find_by_name("Canuto Cup Season 1").delete
  end
end
