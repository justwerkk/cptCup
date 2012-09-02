class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :playerOneWinner
      t.string :playerTwoWinner
      t.string :playerOneLoser
      t.string :playerTwoLoser
      t.integer :cupsLeft

      t.timestamps
    end
  end
end
