class LeaguesController < ApplicationController
  before_filter :set_league, :calculate_data, :only => [:show]

  def index
    @leagues = League.order('start_date DESC')
    @player = Player.new
  end

  # GET /leagues/1
  # GET /leagues/1.json
  def show
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
    #refactor this into models, theres prolly a better way to structure this...
    game_hash = {}
    Player.all.each {|player| game_hash[player.id] = PlayerComparison.new }

    @league.games.each do |g|
      game_hash[g.winner_one_id].add_wins_against(g.loser_one_id, g.loser_two_id)
      game_hash[g.winner_two_id].add_wins_against(g.loser_one_id, g.loser_two_id)
      game_hash[g.loser_one_id].add_loses_against(g.winner_one_id, g.winner_two_id)
      game_hash[g.loser_two_id].add_loses_against(g.winner_one_id, g.winner_two_id)
    end
    @game_hash = {}
    game_hash.to_a.each {|arr| @game_hash[arr.first] = arr.last.against_hash.to_a}

    #refactor this to a call to the League for players
    @players_hash = Player.all.inject({}) do |hash, p|
      hash[p.id] = p.name; hash
    end.select {|player_id| @game_hash[player_id].present?}

    @game_hash.reject! {|player_id, games_arr| games_arr.empty? }

    #refactor this, move it to League, doesnt need any params...
    @player_rankings = Game.calculate_rankings(@league.games)
  end
end
