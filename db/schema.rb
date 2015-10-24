# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20151024054420) do

  create_table "games", :force => true do |t|
    t.integer  "player_one_id",       :null => false
    t.integer  "player_two_id",       :null => false
    t.integer  "player_three_id",     :null => false
    t.integer  "player_four_id",      :null => false
    t.integer  "cups_left"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.integer  "league_id"
    t.boolean  "is_team_one_victory"
  end

  create_table "leagues", :force => true do |t|
    t.string "name"
    t.date   "start_date"
    t.date   "end_date"
  end

  create_table "players", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "shots", :force => true do |t|
    t.integer  "game_id"
    t.integer  "player_id"
    t.boolean  "is_hit"
    t.integer  "cup_position"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "rack_num"
  end

end
