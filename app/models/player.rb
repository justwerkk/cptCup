class Player < ActiveRecord::Base
  attr_accessible :name
  validates_uniqueness_of :name
  validates_presence_of :name

  has_many :games, dependent: :restrict, :finder_sql =>
    Proc.new {"SELECT * FROM games INNER JOIN players ON games.player_one_id = #{id} OR games.player_two_id = #{id} OR games.player_three_id = #{id} OR games.player_four_id = #{id}"}

end
