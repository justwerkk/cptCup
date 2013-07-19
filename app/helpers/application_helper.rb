module ApplicationHelper
  def player_names
    Player.all.sort_by(&:name).collect {|p| [ p.name, p.id ]}
  end

  def leagues
    League.order("name ASC").collect {|l| [l.name, l.id]}
  end
end
