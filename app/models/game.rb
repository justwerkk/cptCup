class Game < ActiveRecord::Base
  belongs_to :winner_one, class_name: "Player", foreign_key: "winner_one_id"
  belongs_to :winner_two, class_name: "Player", foreign_key: "winner_two_id"
  belongs_to :loser_one, class_name: "Player", foreign_key: "loser_one_id"
  belongs_to :loser_two, class_name: "Player", foreign_key: "loser_two_id"
  belongs_to :league

  attr_accessible :cups_left,
    :winner_one_id, :winner_two_id, :loser_one_id, :loser_two_id,
    :winner_one, :winner_two, :loser_one, :loser_two, :league

  attr_reader :team_1_score, :team_2_score

  validates_presence_of :winner_one_id, :winner_two_id, :loser_one_id, :loser_two_id, :league_id
  validate :not_same_player

  def expected_outcome
    return false unless winner_one && winner_two && loser_one && loser_two

    players_score = Game.calculate_rankings(league.games)

    @team_1_score = players_score[winner_one.id] + players_score[winner_two.id]
    @team_2_score = players_score[loser_one.id] + players_score[loser_two.id]

    team_1_expected = 1 / ( 1 + 10 ** ((team_2_score - team_1_score)/400))
    team_2_expected = 1 / ( 1 + 10 ** ((team_1_score - team_2_score)/400))

    return team_1_expected, team_2_expected
  end

  def total_winner_score
    unless @team_1_score
      players_score = Game.calculate_rankings(league.games)

      @team_1_score = players_score[winner_one.name] + players_score[winner_two.name]
    end

    @team_1_score
  end

  def total_loser_score
    unless@team_2_score
      players_score = Game.calculate_rankings(league.games)

      @team_2_score = players_score[loser_one.name] + players_score[loser_two.name]
    end

    @team_2_score
  end

  def self.calculate_rankings(games)
    calculate_rankings(games, Player.select("id").all)
  end

  def self.calculate_rankings(games, player_ids)
    players_score = player_ids.inject({}) do |hash, p_id|
      if hash[p_id].blank?
        hash[p_id] = 1200
      end
      hash
    end

    games.each do |g|
      winner_one_score = players_score[g.winner_one.id]
      winner_two_score = players_score[g.winner_two.id]
      loser_one_score = players_score[g.loser_one.id]
      loser_two_score = players_score[g.loser_two.id]
      players_score[g.winner_one.id] += 16*(1-1/(1.0+10**(((loser_one_score + loser_two_score)-(winner_one_score + winner_two_score))/400.0)))
      players_score[g.winner_two.id] += 16*(1-1/(1.0+10**(((loser_one_score + loser_two_score)-(winner_one_score + winner_two_score))/400.0)))
      players_score[g.loser_one.id] += 16*(0-1/(1.0+10**(((winner_one_score + winner_two_score)-(loser_one_score + loser_two_score))/400.0)))
      players_score[g.loser_two.id] += 16*(0-1/(1.0+10**(((winner_one_score + winner_two_score)-(loser_one_score + loser_two_score))/400.0)))
    end
    players_score
  end

  def build_default_assocations
    self.build_winner_one unless self.winner_one
    self.build_winner_two unless self.winner_two
    self.build_loser_one unless self.loser_one
    self.build_loser_two unless self.loser_two
  end

  private

  def not_same_player
    if [self.winner_one_id, self.winner_two_id, self.loser_one_id, self.loser_two_id].uniq.size != 4
      self.errors.add(:base, "Can't add the same player fool!")
    end
  end
end
