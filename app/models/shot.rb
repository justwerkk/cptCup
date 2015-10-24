class Shot < ActiveRecord::Base
  attr_accessible :cup_position, :game_id, :is_hit, :player_id
  belongs_to :game
  belongs_to :player
  validate :unique_cups

  def player_name
    player.name
  end

  def team
    [game.player_one_id, game.player_two_id].include?(player_id) ? 1 : 2
  end

  private

  def unique_cups
    if self.team == 1
      if game.shots.where(player_id: game.player_one_id, cup_position: cup_position, is_hit: true).exists? || game.shots.where(player_id: game.player_two_id, cup_position: cup_position, is_hit: true).exists?
        self.errors.add(:cup_position, "cant hit the same cup twice")
      end
    else
      if game.shots.where(player_id: game.player_three_id, cup_position: cup_position, is_hit: true).exists? || game.shots.where(player_id: game.player_four_id, cup_position: cup_position, is_hit: true).exists?
        self.errors.add(:cup_position, "cant hit the same cup twice")
      end
    end
  end
end
