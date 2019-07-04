class Timesheet < ApplicationRecord
  validates_presence_of :date, :start_time, :finish_time
  validate :can_not_overlap_other_entries
  validate :date_can_not_be_in_the_future
  validate :finish_time_can_not_be_before_start_time

  before_create :set_value

  scope :user_id_is, -> (id) { where(user_id: id) }

  def friendly_format
    "#{date}: #{start_time.strftime('%H:%M')} - #{finish_time.strftime('%H:%M')} $#{value.round(2)}"
  end

  private

  def set_value
    if [1, 3, 5].include?(date.wday)
      duration_in_range = [finish_time, finish_time.change(hour: 19, min: 0)].min - [start_time, start_time.change(hour: 7, min: 0)].max
      self.value = (duration_in_range / 3600.0 * 22) + ((finish_time - start_time - duration_in_range) / 3600.0 * 33)
    elsif [2, 4].include?(date.wday)
      duration_in_range = [finish_time, finish_time.change(hour: 17, min: 0)].min - [start_time, start_time.change(hour: 5, min: 0)].max
      self.value = (duration_in_range / 3600.0 * 25) + ((finish_time - start_time - duration_in_range) / 3600.0 * 35)
    elsif [6, 0].include?(date.wday)
      self.value = (finish_time - start_time) / 3600.0 * 47
    end
  end

  def date_can_not_be_in_the_future
    errors.add(:date, 'can not be in the future') if date > Date.today
  end

  def finish_time_can_not_be_before_start_time
    errors.add(:finish_time, 'can not be before start time') if finish_time <= start_time
  end

  def can_not_overlap_other_entries
    if self.class.where("date = ? and (start_time, finish_time) OVERLAPS (TIME ?, TIME ?)", date, start_time, finish_time).present?
      errors.add(:base, 'This entry is overlapping another one')
    end
  end
end
