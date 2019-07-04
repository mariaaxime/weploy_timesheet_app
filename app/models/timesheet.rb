class Timesheet < ApplicationRecord
  validates_presence_of :date, :start_time, :finish_time
  validate :can_not_overlap_other_entries
  validate :date_can_not_be_in_the_future
  validate :finish_time_can_not_be_before_start_time

  scope :user_id_is, -> (id) { where(user_id: id) }

  COST_PER_HOUR = {
    [1, 3, 5] => [
      [(0..6), 33],
      [(7..18), 22],
      [(19..23), 33]
    ],
    [2, 4] => [
      [(0..4), 35],
      [(6..16), 25],
      [(17..23), 35]
    ],
    [6, 0] => [
      [(0..23), 47]
    ]
  }

  private

  def date_can_not_be_in_the_future
    errors.add(:date, 'can not be in the future') if date > Date.today
  end

  def finish_time_can_not_be_before_start_time
    errors.add(:finish_time, 'can not be before start time') if finish_time <= start_time
  end

  def can_not_overlap_other_entries
    if (self.class.where("(start_time between :start_time and :finish_time) or finish_time between :start_time and :finish_time", start_time: start_time, finish_time: finish_time).present? ||
        self.class.where("start_time <= ? and finish_time >= ?", start_time, finish_time).present?)
      errors.add(:base, 'This entry is overlapping another one')
    end
  end
end
