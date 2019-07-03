class TimesheetsController < ApplicationController
  def index
    @timesheets = Timesheet.all.page(params[:page])
  end

  def new
    @timesheet = Timesheet.new
  end

  def create
    @timesheet = Timesheet.new(timesheet_params)

  end

  private

  def timesheet_params
    params.require(:timesheet).permit(:date, :start_time, :finish_time)
  end

end
