class HomeController < ApplicationController
  def index
    @players = Player.all
    @game = Game.new
    @game.build_default_assocations
    @num_games = Game.count
  end
end
