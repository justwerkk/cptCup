Player.destroy_all

all_players = []

(1 ..50).each do |i|
  all_players << Player.create(:name => "Player #{i}")
end

1000.times do
  Game.create(:winner_one => all_players.sample,
              :winner_two => all_players.sample,
              :loser_one => all_players.sample,
              :loser_two => all_players.sample
              )
end
