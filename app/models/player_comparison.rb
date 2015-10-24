class PlayerComparison
  attr_reader :against_hash

  WINS_INDEX              = 0
  LOSSES_INDEX            = 1
  HIT_SHOTS_INDEX         = 2
  MISSED_SHOTS_INDEX      = 3
  THREE_RACK_HITS_INDEX   = 4
  THREE_RACK_MISSED_INDEX = 5
  CUPS_LEFT               = 6

  # @against_hash maps the record against each player
  # { player_id => [wins, losses, shots_made, shots_missed], etc... }
  def initialize
    @against_hash = {}
  end

  def add_loses_against(winner_one_id, winner_two_id, cups_left)
    @against_hash[winner_one_id] ||= [0,0,0,0,0,0,0]
    @against_hash[winner_two_id] ||= [0,0,0,0,0,0,0]

    @against_hash[winner_one_id][LOSSES_INDEX] += 1
    @against_hash[winner_two_id][LOSSES_INDEX] += 1

    @against_hash[winner_one_id][CUPS_LEFT] -= cups_left
    @against_hash[winner_two_id][CUPS_LEFT] -= cups_left
  end

  def add_wins_against(loser_one_id, loser_two_id, cups_left)
    @against_hash[loser_one_id] ||= [0,0,0,0,0,0,0]
    @against_hash[loser_two_id] ||= [0,0,0,0,0,0,0]

    @against_hash[loser_one_id][WINS_INDEX] += 1
    @against_hash[loser_two_id][WINS_INDEX] += 1

    @against_hash[loser_one_id][CUPS_LEFT] += cups_left
    @against_hash[loser_two_id][CUPS_LEFT] += cups_left
  end

  def add_shot(shot, opponent_1_id, opponent_2_id)
    @against_hash[opponent_1_id] ||= [0,0,0,0,0,0,0]
    @against_hash[opponent_2_id] ||= [0,0,0,0,0,0,0]

    if shot.is_hit?
      @against_hash[opponent_1_id][HIT_SHOTS_INDEX] += 1
      @against_hash[opponent_2_id][HIT_SHOTS_INDEX] += 1

      if shot.is_3_rack?
        @against_hash[opponent_1_id][THREE_RACK_HITS_INDEX] += 1
        @against_hash[opponent_2_id][THREE_RACK_HITS_INDEX] += 1
      end
    else
      @against_hash[opponent_1_id][MISSED_SHOTS_INDEX] += 1
      @against_hash[opponent_2_id][MISSED_SHOTS_INDEX] += 1

      if shot.is_3_rack?
        @against_hash[opponent_1_id][THREE_RACK_MISSED_INDEX] += 1
        @against_hash[opponent_2_id][THREE_RACK_MISSED_INDEX] += 1
      end
    end
  end

end
