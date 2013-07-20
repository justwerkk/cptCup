class AddWinningTeamToGames < ActiveRecord::Migration
  def change
    rename_column :games, :winner_one_id, :player_one_id
    rename_column :games, :winner_two_id, :player_two_id
    rename_column :games, :loser_one_id, :player_three_id
    rename_column :games, :loser_two_id, :player_four_id

    add_column :games, :is_team_one_victory, :boolean, null: true, default: nil

    Game.update_all(is_team_one_victory: true)
  end
end
