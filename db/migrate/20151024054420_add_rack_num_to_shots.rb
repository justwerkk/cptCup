class AddRackNumToShots < ActiveRecord::Migration
  def change
    add_column :shots, :rack_num, :integer, :after => :cup_position
  end
end
