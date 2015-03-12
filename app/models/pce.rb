class Pce < ActiveRecord::Base
  before_save :set_date

  validates :year, :month, presence: true

  def set_date
    self.date = Date.new(year, month, 1)
  end
end
