# frozen_string_literal: true

# Database Reports user account.
class User < ApplicationRecord
  acts_as_paranoid
  devise :database_authenticatable, :timeoutable, :lockable, :recoverable, :rememberable, :validatable, :trackable
  before_validation :initialize_password, only: :create

  has_many :reports
  has_many :databases

  def admin?
    admin
  end

  private

  def initialize_password
    self.password ||= SecureRandom.alphanumeric(32)
    self.password_confirmation ||= password
  end
end
