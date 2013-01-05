class LeaguesController < ApplicationController
  before_filter :set_league, :calculate_data, :only => [:show]

  # GET /leagues/1
  # GET /leagues/1.json
  def show
    @player = Player.new
    @players = Player.all
    @game = @league.games.build
    @game.build_default_assocations
    @num_games = @league.games.count

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  private

  def set_league
    @league = League.find(params[:id])
  end

  def calculate_data
    game_hash = {}
    @league.games.each do |g|
      game_hash[g.winner_one_id] = PlayerComparison.new unless game_hash[g.winner_one_id]
      game_hash[g.winner_two_id] = PlayerComparison.new unless game_hash[g.winner_two_id]
      game_hash[g.loser_one_id] = PlayerComparison.new unless game_hash[g.loser_one_id]
      game_hash[g.loser_two_id] = PlayerComparison.new unless game_hash[g.loser_two_id]

      game_hash[g.winner_one_id].add_wins_against(g.loser_one_id, g.loser_two_id)
      game_hash[g.winner_two_id].add_wins_against(g.loser_one_id, g.loser_two_id)
      game_hash[g.loser_one_id].add_loses_against(g.winner_one_id, g.winner_two_id)
      game_hash[g.loser_two_id].add_loses_against(g.winner_one_id, g.winner_two_id)
    end
    @game_hash = {}
    game_hash.to_a.each {|arr| @game_hash[arr.first] = arr.last.against_hash.to_a}
    @players_hash = Player.all.inject({}) {|hash, p| hash[p.id] = p.name; hash}
    @player_rankings = Game.calculate_rankings(@league.games)
  end
end
