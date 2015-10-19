class Game < ActiveRecord::Base
  belongs_to :player_one, class_name: "Player", foreign_key: "player_one_id"
  belongs_to :player_two, class_name: "Player", foreign_key: "player_two_id"
  belongs_to :player_three, class_name: "Player", foreign_key: "player_three_id"
  belongs_to :player_four, class_name: "Player", foreign_key: "player_four_id"
  belongs_to :league
  has_many :shots, order: "created_at ASC"

  attr_accessible :cups_left,
    :player_one_id, :player_two_id, :player_three_id, :player_four_id, :league_id,
    :player_one, :player_two, :player_three, :player_four, :league, :is_team_one_victory

  attr_reader :team_1_score, :team_2_score

  validates_presence_of :player_one_id, :player_two_id, :player_three_id, :player_four_id, :league_id
  validate :not_same_player

  ELO_STARTING_SCORE = 1200
  ELO_K_FACTOR = 16
  ELO_MULTIPLIER = 400.0

  def expected_outcome(starting_score = ELO_STARTING_SCORE, k_factor = ELO_K_FACTOR, multiplier = ELO_MULTIPLIER)
    return false unless player_one && player_two && player_three && player_four

    players_score = Game.calculate_rankings(league.games, starting_score, k_factor, multiplier)

    @team_1_score = players_score[player_one.id] + players_score[player_two.id]
    @team_2_score = players_score[player_three.id] + players_score[player_four.id]

    team_1_expected = 1 / ( 1 + 10 ** ((team_2_score - team_1_score)/multiplier))
    team_2_expected = 1 / ( 1 + 10 ** ((team_1_score - team_2_score)/multiplier))

    return team_1_expected, team_2_expected
  end

  def total_winner_score(starting_score = ELO_STARTING_SCORE, k_factor = ELO_K_FACTOR, multiplier = ELO_MULTIPLIER)
    unless @team_1_score
      players_score = Game.calculate_rankings(league.games, starting_score, k_factor, multiplier)

      @team_1_score = players_score[player_one.id] + players_score[player_two.id]
    end

    @team_1_score
  end

  def total_loser_score(starting_score = ELO_STARTING_SCORE, k_factor = ELO_K_FACTOR, multiplier = ELO_MULTIPLIER)
    unless@team_2_score
      players_score = Game.calculate_rankings(league.games, starting_score, k_factor, multiplier)

      @team_2_score = players_score[player_three.id] + players_score[player_four.id]
    end

    @team_2_score
  end

  def self.calculate_rankings(games, starting_score = ELO_STARTING_SCORE, k_factor = ELO_K_FACTOR, multiplier = ELO_MULTIPLIER)
    players_score = Hash.new {|h, k| h[k] = starting_score}

    games.each do |g|
      next if g.is_team_one_victory.nil? #ignore incomplete games

      if g.is_team_one_victory
        winner_one_id = g.player_one.id
        winner_two_id = g.player_two.id
        loser_one_id = g.player_three.id
        loser_two_id = g.player_four.id
      else
        winner_one_id = g.player_three.id
        winner_two_id = g.player_four.id
        loser_one_id = g.player_one.id
        loser_two_id = g.player_two.id
      end

      winning_team_score = players_score[winner_one_id] + players_score[winner_two_id]
      losing_team_score = players_score[loser_one_id] + players_score[loser_two_id]

      winner_points = k_factor*(1-1/(1.0+10**((losing_team_score-winning_team_score)/multiplier)))

      players_score[winner_one_id] += winner_points
      players_score[winner_two_id] += winner_points
      players_score[loser_one_id] -= winner_points
      players_score[loser_two_id] -= winner_points
    end

    players_score
  end

  def team_1_hit_cups
    @team_1_hit_cups ||= self.shots.where(player_id: [player_one_id, player_two_id], is_hit: true).map(&:cup_position)
  end

  def team_2_hit_cups
    @team_2_hit_cups ||= self.shots.where(player_id: [player_three_id, player_four_id], is_hit: true).map(&:cup_position)
  end

  def build_default_assocations
    self.build_player_one unless self.player_one
    self.build_player_two unless self.player_two
    self.build_player_three unless self.player_three
    self.build_player_four unless self.player_four
  end

  def cup_is_hit?(team, cup_position)
    hit_cups = team == 1 ? team_1_hit_cups : team_2_hit_cups
    hit_cups.include?(cup_position)
  end

  def is_pending?
    self.is_team_one_victory.nil?
  end

  def select_winner(winning_team, cups_left)
    if winning_team == 1
      self.is_team_one_victory = true
    elsif winning_team == 2
      self.is_team_one_victory = false
    else
      raise "winning team must be 1 or 2"
    end

    self.cups_left = cups_left

    save!
  end

  private

  def not_same_player
    if [self.player_one_id, self.player_two_id, self.player_three_id, self.player_four_id].uniq.size != 4
      self.errors.add(:base, "Can't add the same player fool!")
    end
  end
end
