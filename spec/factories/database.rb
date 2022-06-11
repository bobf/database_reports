# frozen_string_literal: true

FactoryBot.define do
  factory :database do
    name { Faker::Internet.domain_word }
    adapter { 'mysql' }
    database { Faker::Internet.domain_word }
    username { Faker::Internet.user }
    password { Faker::Internet.password }
    host { Faker::Internet.domain_name(subdomain: true) }
    port { Faker::Number.between(from: 1024, to: 65_535) }
    description { Faker::Lorem.sentence }
    user
  end
end
