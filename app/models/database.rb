# frozen_string_literal: true

class Database < ApplicationRecord
  has_many :databases
  belongs_to :user
end
