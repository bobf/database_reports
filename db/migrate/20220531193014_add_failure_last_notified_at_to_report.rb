# frozen_string_literal: true

class AddFailureLastNotifiedAtToReport < ActiveRecord::Migration[7.0]
  def change
    add_column :reports, :failure_last_notified_at, :datetime
    add_index :reports, :failure_last_notified_at
  end
end
