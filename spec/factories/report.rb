# frozen_string_literal: true

FactoryBot.define do
  factory :report do
    name { 'my report' }
    subject { 'my subject' }
    query { 'select example_column as "example column" from example_table' }
  end
end
