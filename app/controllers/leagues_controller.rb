class LeaguesController < ApplicationController
  before_filter :set_league, :calculate_data, :only => [:show]

  def index
    @leagues = League.all
    @player = Player.new
  end

  # GET /leagues/1
  # GET /leagues/1.json
  def show
    @game = @league.games.build(is_team_one_victory: true)
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
      next if g.is_team_one_victory.nil?
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

      game_hash[winner_one_id].add_wins_against(loser_one_id, loser_two_id)
      game_hash[winner_two_id].add_wins_against(loser_one_id, loser_two_id)
      game_hash[loser_one_id].add_loses_against(winner_one_id, winner_two_id)
      game_hash[loser_two_id].add_loses_against(winner_one_id, winner_two_id)
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
