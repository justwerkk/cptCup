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
    if [game.player_one_id, game.player_two_id].include?(player_id)
      if game.player_one.shots.where(cup_position: cup_position).exists? || game.player_two.shots.where(cup_position: cup_position).exists?
        self.errors.add(:cup_position, "cant hit the same cup twice")
      end
    else
      if game.player_three.shots.where(cup_position: cup_position).exists? || game.player_four.shots.where(cup_position: cup_position).exists?
        self.errors.add(:cup_position, "cant hit the same cup twice")
      end
    end
  end
end
