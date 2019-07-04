class Timesheet < ApplicationRecord
  validates_presence_of :date, :start_time, :finish_time
  validate :can_not_overlap_other_entries
  validate :date_can_not_be_in_the_future
  validate :finish_time_can_not_be_before_start_time

  before_create :calculate_value

  scope :user_id_is, -> (id) { where(user_id: id) }

  def friendly_format
    "#{date}: #{start_time.strftime('%H:%M')} - #{finish_time.strftime('%H:%M')} $#{value}"
  end

  private

  def calculate_value
    if [1, 3, 5].include?(date.wday)
    elsif [2, 4].include?(date.wday)
    elsif [6, 0].include?(date.wday)
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
