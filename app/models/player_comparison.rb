class PlayerComparison
  attr_reader :against_hash

  WINS_INDEX         = 0
  LOSSES_INDEX       = 1
  HIT_SHOTS_INDEX    = 2
  MISSED_SHOTS_INDEX = 3

  # @against_hash maps the record against each player
  # { player_id => [wins, losses, shots_made, shots_missed], etc... }
  def initialize
    @against_hash = {}
  end

  def add_loses_against(winner_one_id, winner_two_id)
    @against_hash[winner_one_id] ||= [0,0,0,0]
    @against_hash[winner_two_id] ||= [0,0,0,0]

    @against_hash[winner_one_id][LOSSES_INDEX] += 1
    @against_hash[winner_two_id][LOSSES_INDEX] += 1
  end

  def add_wins_against(loser_one_id, loser_two_id)
    @against_hash[loser_one_id] ||= [0,0,0,0]
    @against_hash[loser_two_id] ||= [0,0,0,0]

    @against_hash[loser_one_id][WINS_INDEX] += 1
    @against_hash[loser_two_id][WINS_INDEX] += 1
  end

  def add_shot(shot, opponent_1_id, opponent_2_id)
    @against_hash[opponent_1_id] ||= [0,0,0,0]
    @against_hash[opponent_2_id] ||= [0,0,0,0]

    if shot.is_hit?
      @against_hash[opponent_1_id][HIT_SHOTS_INDEX] += 1
      @against_hash[opponent_2_id][HIT_SHOTS_INDEX] += 1
    else
      @against_hash[opponent_1_id][MISSED_SHOTS_INDEX] += 1
      @against_hash[opponent_2_id][MISSED_SHOTS_INDEX] += 1
    end
  end

end
