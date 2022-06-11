# frozen_string_literal: true

class CreateDatabase < ActiveRecord::Migration[7.0]
  def change
    create_table :databases, id: :uuid do |t|
      t.string :name
      t.string :adapter
      t.string :database
      t.string :username
      t.string :password
      t.string :host
      t.integer :port
      t.text :description

      t.timestamps
    end
    add_index :databases, :name
  end
end
