class Game < ActiveRecord::Base
  belongs_to :winner_one, class_name: "Player", foreign_key: "winner_one_id"
  belongs_to :winner_two, class_name: "Player", foreign_key: "winner_two_id"
  belongs_to :loser_one, class_name: "Player", foreign_key: "loser_one_id"
  belongs_to :loser_two, class_name: "Player", foreign_key: "loser_two_id"

  attr_accessible :cups_left,
    :winner_one_id, :winner_two_id, :loser_one_id, :loser_two_id,
    :winner_one, :winner_two, :loser_one, :loser_two

  validates_presence_of :winner_one_id, :winner_two_id, :loser_one_id, :loser_two_id, :cups_left
end
