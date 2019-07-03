class Timesheet < ApplicationRecord
  validates_presence_of :date, :start_time, :finish_time
end
