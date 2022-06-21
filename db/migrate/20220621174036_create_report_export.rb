# frozen_string_literal: true

class CreateReportExport < ActiveRecord::Migration[7.0]
  def change
    create_table :report_exports, id: :uuid do |t|
      t.references :report, null: false, foreign_key: false, type: :uuid
      t.references :user, null: false, foreign_key: false, type: :uuid
      t.string :export_context
      t.jsonb :data

      t.timestamps
    end
  end
end
