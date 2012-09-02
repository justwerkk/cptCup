class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :winner_one_id
      t.integer :winner_two_id
      t.integer :loser_one_id
      t.integer :loser_two_id
      t.integer :cupsLeft

      t.timestamps
    end
  end
end
