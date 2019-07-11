require 'rails_helper'

RSpec.describe Timesheet, type: :model do
  def user
    User.first || User.create!(email: 'maria@gmail.com', password: '123456789')
  end

  context 'validation tests' do
    it 'ensures date presence' do
      timesheet = Timesheet.new(user: user, start_time: '10:00', finish_time: '11:00').save
      expect(timesheet).to eq(false)
    end

    it 'ensures date is not in the future' do
      timesheet = Timesheet.new(user: user, date: Date.tomorrow, start_time: '10:00', finish_time: '11:00').save
      expect(timesheet).to eq(false)
    end

    it 'ensures start_time presence' do
      timesheet = Timesheet.new(user: user, date: Date.today, finish_time: '11:00').save
      expect(timesheet).to eq(false)
    end

    it 'ensures finish_time presence' do
      timesheet = Timesheet.new(user: user, date: Date.today, start_time: '10:00').save
      expect(timesheet).to eq(false)
    end

    it 'ensures finish_time is greater than start_time' do
      timesheet = Timesheet.new(user: user, date: Date.today, start_time: '10:00', finish_time: '9:00').save
      expect(timesheet).to eq(false)
    end

    it 'avoids overlapping entries' do
      timesheet1 = Timesheet.create!(user: user, date: Date.today, start_time: '10:00', finish_time: '11:00')
      timesheet2 = Timesheet.new(user: user, date: Date.today, start_time: '8:00', finish_time: '10:30').save
      expect(timesheet2).to eq(false)
    end

    it 'should save successfully' do
      timesheet = Timesheet.new(user: user, date: Date.today, start_time: '10:00', finish_time: '11:00').save
      expect(timesheet).to eq(true)
    end
  end

  context 'calculation tests' do
    it 'calculates monday value' do
      value = Timesheet.create!(user: user, date: '08/07/2019'.to_date, start_time: '05:00', finish_time: '12:00').value
      expect(value).to eq(209)
    end

    it 'calculates tuesday value' do
      value = Timesheet.create!(user: user, date: '09/07/2019'.to_date, start_time: '00:00', finish_time: '10:00').value
      expect(value).to eq(350)
    end

    # it 'calculates wednesday value' do
    #   value = Timesheet.create!(user: user, date: '17/04/2019'.to_date, start_time: '04:00', finish_time: '21:30').value
    #   expect(value).to eq(445.5)
    # end

    # it 'calculates weekend value' do
    #   value = Timesheet.create!(user: user, date: '20/04/2019'.to_date, start_time: '15:30', finish_time: '20:00').value
    #   expect(value).to eq(211.5)
    # end
  end
end
