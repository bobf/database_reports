# frozen_string_literal: true

class AddDeletedAtToReport < ActiveRecord::Migration[7.0]
  def change
    add_column :reports, :deleted_at, :datetime
    add_index :reports, :deleted_at
  end
end
