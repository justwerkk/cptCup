class League < ActiveRecord::Base
  attr_accessible :end_date, :start_date, :name

  has_many :games, order: "created_at ASC"
  scope :by_start_date, order: 'start_date DESC'
end
