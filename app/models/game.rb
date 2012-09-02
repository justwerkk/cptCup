class Game < ActiveRecord::Base
  attr_accessible :cupsLeft, :playerOneLoser, :playerOneWinner, :playerTwoLoser, :playerTwoWinner
end
