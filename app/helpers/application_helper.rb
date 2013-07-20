module ApplicationHelper
  def player_names
    Player.all.sort_by(&:name).collect {|p| [ p.name, p.id ]}
  end

  def leagues
    League.order("name ASC").collect {|l| [l.name, l.id]}
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
end
