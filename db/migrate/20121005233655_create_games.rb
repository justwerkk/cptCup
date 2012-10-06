class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :winner_one_id, null: false
      t.integer :winner_two_id, null: false
      t.integer :loser_one_id, null: false
      t.integer :loser_two_id, null: false
      t.integer :cups_left

      t.timestamps
    end
  end
end
