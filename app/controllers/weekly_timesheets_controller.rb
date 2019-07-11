class WeeklyTimesheetsController < ApplicationController
  def index
    timesheets = current_user.timesheets.order(:date)
    start_date = timesheets.first.date.beginning_of_week
    end_date = timesheets.last.date.beginning_of_week
    @weekly_summary = {}
    while start_date <= end_date
      this_week_timesheets = timesheets.where(date: start_date..start_date.end_of_week)
      @weekly_summary[start_date] = this_week_timesheets.map{|t| [t.friendly_format]}
      start_date = start_date + 1.week
    end
  end
end
