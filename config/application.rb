# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'
require 'csv'

Bundler.require(*Rails.groups)

module DatabaseReports
  EXPECTED_DATABASE_ERRORS = [ActiveRecord::StatementInvalid, ActiveRecord::DatabaseConnectionError].freeze

  # Database report generator and emailer.
  class Application < Rails::Application
    config.load_defaults 7.0
  end
end
