# frozen_string_literal: true

ENV['REDIS_URL'] ||= Rails.application.config_for(:redis)['url']
