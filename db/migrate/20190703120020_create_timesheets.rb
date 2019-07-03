class CreateTimesheets < ActiveRecord::Migration[5.2]
  def change
    create_table :timesheets do |t|
      t.date :date
      t.time :start_time
      t.time :finish_time
      t.decimal :value

      t.timestamps
    end
  end
end
