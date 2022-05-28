# frozen_string_literal: true

class CreateReport < ActiveRecord::Migration[7.0]
  def change
    create_table :reports, id: :uuid do |t|
      t.string :name
      t.text :query
      t.text :subject
      t.jsonb :to_recipients
      t.jsonb :cc_recipients
      t.jsonb :bcc_recipients

      t.timestamps
    end
  end
end
