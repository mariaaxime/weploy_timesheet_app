class TimesheetsController < ApplicationController
  def index
    @timesheets = Timesheet.all.page(params[:page])
  end

  def new
    @timesheet = Timesheet.new
  end

  def create
    @timesheet = Timesheet.new(timesheet_params)

    if @timesheet.save
      flash[:success] = 'Timesheet entry created successfully'
      redirect_to root_path
    else
      flash[:danger] = 'The timesheet entry could not be created'
      render 'new'
    end
  end

  private

  def timesheet_params
    params.require(:timesheet).permit(:date, :start_time, :finish_time)
  end

end
