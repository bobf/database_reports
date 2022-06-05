# frozen_string_literal: true

class ModifyUserUniqueIndexScope < ActiveRecord::Migration[7.0]
  def change
    remove_index :users, :email
    add_index :users, :email
    add_index :users, %i[email deleted_at], unique: true
  end
end
