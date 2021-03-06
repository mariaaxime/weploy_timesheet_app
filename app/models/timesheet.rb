class Timesheet < ApplicationRecord
  belongs_to :user

  validates_presence_of :user, :date, :start_time, :finish_time
  validate :can_not_overlap_other_entries
  validate :date_can_not_be_in_the_future
  validate :finish_time_can_not_be_before_start_time
  validate :finish_time_can_not_be_equal_to_start_time

  before_create :set_value

  def friendly_format
    "#{date}: #{start_time.strftime('%H:%M')} - #{finish_time.strftime('%H:%M')} $#{value.round(2)}"
  end

  VALUE_PER_DAY = {
    [1, 3, 5] => [
      [{start_hour: 7, start_minute: 0, finish_hour: 19, finish_minute: 0, value: 22}],
      33
     ],
    [2, 4] => [
      [{start_hour: 5, start_minute: 0, finish_hour: 17, finish_minute: 0, value: 25}],
      35
     ],
    [6, 0] => [
      [],
      47
     ],
  }

  LIMIT = 4
  #

  # 00am - 10am
  # 0am - 5am (Outside the range) ($175)
  # 5am - 10am (Outside) ($175)
  # ($350)

  private

  def set_value
    VALUE_PER_DAY.each do |wday_array, (ranges, outside_value)|
      if wday_array.include?(date.wday)
        duration_in_ranges = 0
        total_value = 0
        ranges.each do |range|
          limit_finish_time = [finish_time, start_time + LIMIT.hours].min
          range_start_time = [start_time, start_time.change(hour: range[:start_hour], min: range[:start_minute])].max
          range_finish_time = [limit_finish_time, finish_time.change(hour: range[:finish_hour], min: range[:finish_minute])].min
          duration_in_range = range_finish_time < range_start_time ? 0 : range_finish_time - range_start_time
          total_value += duration_in_range / 3600.0 * range[:value]
          duration_in_ranges += duration_in_range
        end
        total_value += (finish_time - start_time - duration_in_ranges) / 3600.0 * outside_value
        self.value = total_value
      end
    end
  end

  def date_can_not_be_in_the_future
    errors.add(:date, 'can not be in the future') if date.present? && date > Date.today
  end

  def finish_time_can_not_be_before_start_time
    errors.add(:finish_time, 'can not be before start time') if start_time.present? && finish_time.present? && finish_time < start_time
  end

  def finish_time_can_not_be_equal_to_start_time
    errors.add(:finish_time, 'can not be equal to start time') if start_time.present? && finish_time.present? && finish_time == start_time
  end

  def can_not_overlap_other_entries
    if start_time.present? && finish_time.present?
      if self.class.where("user_id = ? and date = ? and (start_time, finish_time) OVERLAPS (TIME ?, TIME ?)", user_id, date, start_time, finish_time).present?
        errors.add(:base, 'This entry is overlapping another one')
      end
    end
  end
end
