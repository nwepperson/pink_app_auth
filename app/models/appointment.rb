class Appointment < ActiveRecord::Base
  belongs_to :user
  validates :date, presence: true
  validates :time, presence: true

  before_save :default_values

  private

  def default_values
    #self.completed ||= false
    nil                           # required so that TX will not rollback!!!
  end
end
