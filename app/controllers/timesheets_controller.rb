class TimesheetsController < ApplicationController
  def index
    @timesheets = Timesheet.all.page(params[:page])
  end

  def new
  end

  def create
  end

end
