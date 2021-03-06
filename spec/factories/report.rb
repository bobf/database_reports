# frozen_string_literal: true

FactoryBot.define do
  factory :report do
    name { 'my report' }
    subject { 'my subject' }
    query { 'select example_column as "example column" from example_table' }
    to_recipients { ['to@example.com'] }
    schedule_type { 'none' }
    user
    database
    report_exports { build_list(:report_export, 1) }
  end
end
