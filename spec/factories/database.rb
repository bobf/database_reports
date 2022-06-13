# frozen_string_literal: true

FactoryBot.define do
  config = Rails.application.config_for('database.reports')

  factory :database do
    name { Faker::Internet.domain_word }
    adapter { config[:adapter] }
    database { config[:database] }
    username { config[:username] }
    password { config[:password] }
    host { config[:host] }
    port { config[:port] }
    description { Faker::Lorem.sentence }
    user
  end
end
