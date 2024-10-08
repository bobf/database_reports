# frozen_string_literal: true

require 'active_support/core_ext/integer/time'

Rails.application.configure do
  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true
  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?
  config.assets.compile = false
  config.active_storage.service = :local
  config.log_level = :info
  config.log_tags = [:request_id]
  config.action_mailer.default_url_options = {
    protocol: ENV.fetch('MAILER_URL_PROTOCOL', 'https'),
    host: ENV.fetch('MAILER_URL_HOST', 'example.com'),
    port: ENV.fetch('MAILER_URL_PORT', nil)
  }
  config.action_mailer.smtp_settings = {
    address: ENV.fetch('MAILER_SMTP_HOST', nil),
    port: ENV.fetch('MAILER_SMTP_PORT', '25').to_i,
    domain: ENV.fetch('MAILER_SMTP_DOMAIN', 'example.com'),
    user_name: ENV.fetch('MAILER_SMTP_USER', nil),
    password: ENV.fetch('MAILER_SMTP_PASSWORD', nil)
    enable_starttls: ENV.key?('MAILER_SMTP_STARTTLS'),
    authentication: ENV.fetch('MAILER_SMTP_AUTHENTICATION', 'plain').to_sym,
  }.compact
  config.action_mailer.perform_caching = false
  config.i18n.fallbacks = true
  config.active_support.report_deprecations = false
  config.log_formatter = ::Logger::Formatter.new
  if ENV['RAILS_LOG_TO_STDOUT'].present?
    logger           = ActiveSupport::Logger.new($stdout)
    logger.formatter = config.log_formatter
    config.logger    = ActiveSupport::TaggedLogging.new(logger)
  end
  config.active_record.dump_schema_after_migration = false
end
