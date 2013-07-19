class League < ActiveRecord::Base
  attr_accessible :end_date, :start_date, :name
  validates_presence_of :name, :start_date

  has_many :games, order: "created_at ASC"
  default_scope order: 'start_date DESC'
end
