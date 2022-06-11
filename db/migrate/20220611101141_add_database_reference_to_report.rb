# frozen_string_literal: true

class AddDatabaseReferenceToReport < ActiveRecord::Migration[7.0]
  def change
    add_reference :reports, :database, null: false, foreign_key: true, type: :uuid
  end
end
