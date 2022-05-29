# frozen_string_literal: true

# Configuration for a scheduled database query report.
class Report < ApplicationRecord
  validates_presence_of :name
  validates_presence_of :subject
  validates_presence_of :query

  FILENAME_CHARACTERS = ('a'..'z').to_a + ('A'..'Z').to_a + ['0'..'9'].to_a + [' '] + %w[-_()]

  def to_recipients=(val)
    super(translated_email_addresses(val))
  end

  def cc_recipients=(val)
    super(translated_email_addresses(val))
  end

  def bcc_recipients=(val)
    super(translated_email_addresses(val))
  end

  def csv
    ([output.columns] + output.rows).map(&:to_csv).join
  end

  def output
    @output ||= ReportRecord.connection.select_all(query)
  end

  def filename
    "#{sanitized_name} #{Time.now.utc.strftime('%Y-%m-%d %H_%M_%S')}.csv"
  end

  private

  def sanitized_name
    name.chars.select { |char| FILENAME_CHARACTERS.include?(char) }.join
  end

  def translated_email_addresses(addresses)
    return addresses unless addresses.is_a?(String)

    addresses.split(',').map(&:strip)
  end
end
