module ApplicationHelper
  def player_names
    Player.all.sort_by(&:name).collect {|p| [ p.name, p.id ]}
  end
end
