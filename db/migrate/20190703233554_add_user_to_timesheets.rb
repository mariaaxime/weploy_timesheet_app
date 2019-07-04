class AddUserToTimesheets < ActiveRecord::Migration[5.2]
  def change
    add_reference :timesheets, :user, foreign_key: true
  end
end
