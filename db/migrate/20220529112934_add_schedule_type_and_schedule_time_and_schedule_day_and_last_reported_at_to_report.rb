# frozen_string_literal: true

class AddScheduleTypeAndScheduleTimeAndScheduleDayAndLastReportedAtToReport < ActiveRecord::Migration[7.0]
  def change
    add_column :reports, :schedule_day, :integer
    add_index :reports, :schedule_day
    add_column :reports, :schedule_time, :time
    add_index :reports, :schedule_time
    add_column :reports, :schedule_type, :string
    add_index :reports, :schedule_type
    add_column :reports, :last_reported_at, :datetime
    add_index :reports, :last_reported_at
  end
end
