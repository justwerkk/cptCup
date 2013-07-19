class League < ActiveRecord::Base
  attr_accessible :end_date, :start_date, :name
  validates_presence_of :name, :start_date

  default_scope order: 'start_date DESC'

  has_many :games, order: "created_at ASC", dependent: :restrict

  before_destroy :validate_not_completed

  private

  def validate_not_completed
    unless end_date.nil?
      self.errors.add(:base, "cant delete a league that's completed")
      return false
    end
  end
end
