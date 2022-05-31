# frozen_string_literal: true

# Configuration for a scheduled database query report.
class Report < ApplicationRecord
  acts_as_paranoid

  belongs_to :user

  validates_presence_of :name
  validates_presence_of :subject
  validates_presence_of :query
  validate :validate_schedule_time

  scope :due_daily, lambda {
    now = Time.now.utc
    where(
      schedule_type: 'daily',
      schedule_time: ..now
    )
  }

  scope :due_weekly, lambda {
    now = Time.now.utc
    where(
      schedule_type: 'weekly',
      schedule_day: now.wday,
      schedule_time: ..now
    )
  }

  scope :due, -> { due_weekly.or(due_daily).select(&:due?) }

  FILENAME_CHARACTERS = ('a'..'z').to_a + ('A'..'Z').to_a + ['0'..'9'].to_a + [' '] + %w[-_()]

  def due?
    return false if translated_schedule_time.blank?
    return false if now < translated_schedule_time
    return false if last_reported_at.present? && last_reported_at >= translated_schedule_time

    true
  end

  def failure_notified_since_success?
    return false if failure_last_notified_at.blank?
    return true if last_reported_at.blank?

    failure_last_notified_at < last_reported_at
  end

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
    @output ||= ReportRecord.select_all(query)
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

  def now
    @now ||= Time.now.utc
  end

  def translated_schedule_time
    case schedule_type
    when 'daily'
      daily_schedule_time
    when 'weekly'
      weekly_schedule_time
    end
  end

  def daily_schedule_time
    now.beginning_of_day + schedule_time.hour.hours + schedule_time.min.minutes
  end

  def weekly_schedule_time
    now.beginning_of_week + schedule_day.days + schedule_time.hour.hours + schedule_time.min.minutes
  end

  def validate_schedule_time
    return if schedule_time.blank? && schedule_type == 'none'
    return if schedule_time.is_a?(Time)

    hour, _, minute = schedule_time.partition(':')
    return if (0..24).cover?(Integer(hour)) && (0..59).cover(Integer(minute))

    errors.add(:schedule_time, 'must be in format HH:MM, e.g. 14:30')
  rescue ArgumentError, NoMethodError
    errors.add(:schedule_time, 'must be in format HH:MM, e.g. 14:30')
  end
end
