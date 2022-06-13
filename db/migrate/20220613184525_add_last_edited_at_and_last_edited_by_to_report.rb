# frozen_string_literal: true

class AddLastEditedAtAndLastEditedByToReport < ActiveRecord::Migration[7.0]
  def change
    add_column :reports, :last_edited_at, :datetime
    add_column :reports, :last_edited_by_user_id, :uuid
  end
end
