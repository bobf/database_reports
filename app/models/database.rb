# frozen_string_literal: true

# Database connection configuration used for generating reports.
class Database < ApplicationRecord
  has_many :databases
  belongs_to :user

  def self.adapters
    [
      { name: 'mysql2', label: 'MySQL' },
      { name: 'postgresql', label: 'PostgreSQL' }
    ]
  end

  def to_h
    { adapter:, host:, port:, username:, password:, database: }
  end

  def adapter(humanize: false)
    return self[:adapter] unless humanize

    self.class.adapters.find { |adapter| adapter[:name] == self[:adapter] }&.fetch(:label) || self[:adapter]
  end

  def password=(val)
    super unless val.blank?
  end
end
