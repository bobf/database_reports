# frozen_string_literal: true

# Database Reports user account.
class User < ApplicationRecord
  acts_as_paranoid
  devise :database_authenticatable, :timeoutable, :lockable, :recoverable, :rememberable, :validatable, :trackable

  has_many :reports

  def admin?
    admin
  end
end
