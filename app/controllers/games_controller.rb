class GamesController < ApplicationController
  before_filter :set_league

  # GET /games
  # GET /games.json
  def index
    @games = @league.games.reorder("created_at DESC")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @games }
    end
  end

  # GET /games/1
  # GET /games/1.json
  def show
    @game = Game.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @game }
    end
  end

  # GET /games/new
  # GET /games/new.json
  def new
    @game = @league.games.build
    @game.build_default_assocations
    @players = Player.all

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @game }
    end
  end

  # GET /games/1/edit
  def edit
    @game = Game.find(params[:id])
    @players = Player.all
  end

  # POST /games
  # POST /games.json
  def create
    @game = @league.games.build(params[:game])
    use_interactive_mode = params[:mode] == "interactive"
    @game.is_team_one_victory = true unless use_interactive_mode

    respond_to do |format|
      if @game.save
        format.html do
          if use_interactive_mode
            redirect_to shot_tracker_league_game_url(@league, @game), notice: 'Game was successfully created.'
          else
            redirect_to @league, notice: 'Game was successfully created.'
          end
        end
        format.json { render json: @game, status: :created, location: @game }
      else
        @players = Player.all
        format.html { render action: "new" }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  def select_winner
    @game = Game.find(params[:id])
    cups_left = params[:cups_left].to_i
    winning_team = params[:winning_team].to_i

    @game.select_winner(winning_team, cups_left)

    redirect_to @league, notice: 'Game was successfully recorded!'
  end

  # PUT /games/1
  # PUT /games/1.json
  def update
    @game = Game.find(params[:id])

    respond_to do |format|
      if @game.update_attributes(params[:game])
        format.html { redirect_to league_game_path(@league, @game), notice: 'Game was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /games/1
  # DELETE /games/1.json
  def destroy
    @game = Game.find(params[:id])
    @game.destroy

    respond_to do |format|
      format.html { redirect_to league_games_url }
      format.json { head :no_content }
    end
  end

  def odds
    @game = @league.games.build(params[:game])
    @players = Player.all

    respond_to do |format|
      @game.build_default_assocations unless @expected_outcome = @game.expected_outcome
      format.html {  }
    end
  end

  def shot_tracker
    @game = Game.find(params[:id])
    raise "Cannot use shot_tracker on completed game" unless @game.is_pending?
  end

  # POST /games/1/shots
  def shots_index
    @shots = Shot.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @shots }
    end
  end

  def create_shot
    @game = Game.find(params[:id])
    @shot = @game.shots.build(params[:shot])

    respond_to do |format|
      format.json do
        if @shot.save
          render json: @shot.to_json(:methods => [:player_name, :team])
        else
          render json: @shot.errors, status: :unprocessable_entity
        end
      end
    end
  end

  private

  def set_league
    @league = League.find(params[:league_id])
  end

end
