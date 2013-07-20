class CreateShots < ActiveRecord::Migration
  def change
    create_table :shots do |t|
      t.integer :game_id
      t.integer :player_id
      t.boolean :is_hit
      t.integer :cup_position

      t.timestamps
    end
  end
end
