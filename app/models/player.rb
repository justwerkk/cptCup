class Player < ActiveRecord::Base
  attr_accessible :name
  validates_uniqueness_of :name
  validates_presence_of :name

  has_many :games, dependent: :restrict, :finder_sql =>
    Proc.new {"SELECT * FROM games INNER JOIN players ON games.winner_one_id = #{id} OR games.winner_two_id = #{id} OR games.loser_one_id = #{id} OR games.loser_two_id = #{id}"}

end
