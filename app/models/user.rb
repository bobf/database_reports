# frozen_string_literal: true

class User < ApplicationRecord
  acts_as_paranoid
  devise :database_authenticatable, :timeoutable, :lockable, :recoverable, :rememberable, :validatable, :trackable

  has_many :reports
end
