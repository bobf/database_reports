# frozen_string_literal: true

class CreateExampleTable < ActiveRecord::Migration[7.0]
  def change
    create_table :example_table do |t|
      t.string :example_column

      t.timestamps
    end
  end
end
