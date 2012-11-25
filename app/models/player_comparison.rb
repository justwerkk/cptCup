class PlayerComparison
  attr_reader :against_hash

  def initialize
    @against_hash = {}
  end

  def add_loses_against(winner_one_id, winner_two_id)
    @against_hash[winner_one_id] = [0,0] unless @against_hash[winner_one_id]
    @against_hash[winner_two_id] = [0,0] unless @against_hash[winner_two_id]

    @against_hash[winner_one_id][1] += 1
    @against_hash[winner_two_id][1] += 1
  end

  def add_wins_against(loser_one_id, loser_two_id)
    @against_hash[loser_one_id] = [0,0] unless @against_hash[loser_one_id]
    @against_hash[loser_two_id] = [0,0] unless @against_hash[loser_two_id]

    @against_hash[loser_one_id][0] += 1
    @against_hash[loser_two_id][0] += 1
  end
end
