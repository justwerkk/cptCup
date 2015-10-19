module ApplicationHelper
  def player_names
    Player.all.sort_by(&:name).collect {|p| [ p.name, p.id ]}
  end

  def leagues
    League.order("name ASC").collect {|l| [l.name, l.id]}
  end

  def options_for_game_winner
    [["Pending", nil],["Team 1", true],["Team 2", false]]
  end

  def winner_string(game)
    case game.is_team_one_victory
    when nil
      "Pending"
    when true
      "Team 1"
    when false
      "Team 2"
    end
  end

  def team_for_shot(shot)
    [shot.game.player_one_id, shot.game.player_two_id].include?(shot.player_id) ? 1 : 2
  end

  def hit_or_miss(shot)
    shot.is_hit ? "hit" : "miss"
  end

  def check_hit(game, team, cup_position)
    game.cup_is_hit?(team, cup_position) ? " hit" : ""
  end

  def cup_position(shot)
    if shot.is_hit
      " (cup ##{shot.cup_position})"
    else
      ""
    end
  end
end
