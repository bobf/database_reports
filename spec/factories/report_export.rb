# frozen_string_literal: true

FactoryBot.define do
  factory :report_export do
    data { { columns: [{ name: 'example column' }], rows: [['example value']] } }
    export_context { 'web_email' }
    user
  end
end
