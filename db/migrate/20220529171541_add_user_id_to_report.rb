# frozen_string_literal: true

class AddUserIdToReport < ActiveRecord::Migration[7.0]
  def change
    add_reference :reports, :user, null: false, foreign_key: true, type: :uuid
  end
end
