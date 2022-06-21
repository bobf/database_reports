# frozen_string_literal: true

# A recorded export of a report query.
class ReportExport < ApplicationRecord
  belongs_to :report
  belongs_to :user

  validates :export_context, inclusion: { in: %w[web_view web_email web_export scheduled_export] }

  def rows
    return [] unless data.is_a?(Hash) && data['rows'].present?

    data.fetch('rows')
  end

  def columns
    return [] unless data.is_a?(Hash) && data['columns'].present?

    data.fetch('columns', [])&.map { |column_spec| column_spec['name'] }
  end

  def user_display
    user.presence&.email || '[User deleted]'
  end

  def csv
    ([columns] + rows).map(&:to_csv).join
  end

  def filename
    "#{report&.sanitized_name} #{created_at&.strftime('%Y-%m-%d %H_%M_%S')}.csv"
  end
end
