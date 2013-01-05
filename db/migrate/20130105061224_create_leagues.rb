class CreateLeagues < ActiveRecord::Migration
  def up
    create_table :leagues do |t|
      t.string :name, required: true
      t.date :start_date, nil: true
      t.date :end_date, nil: true
    end

    add_column :games, :league_id, :string, required: true
  end

  def down
    drop_table :leagues

    remove_column :games, :league_id
  end
end
