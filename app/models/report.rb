# frozen_string_literal: true

# Configuration for a scheduled database query report.
class Report < ApplicationRecord
  acts_as_paranoid

  belongs_to :user
  belongs_to :last_edited_by, class_name: 'User', foreign_key: :last_edited_by_user_id, required: false
  belongs_to :database, required: false
  has_many :report_exports

  validates_presence_of :name
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

  def subject
    self[:subject].presence || name
  end

  def due?
    return false if normalized_schedule_time.blank?
    return false if now < normalized_schedule_time
    return false if last_reported_at.present? && last_reported_at >= normalized_schedule_time

    true
  end

  def user_display
    user.presence&.email || '[User deleted]'
  end

  def failure_notified_since_success?
    return false if failure_last_notified_at.blank?
    return true if last_reported_at.blank?

    failure_last_notified_at < last_reported_at
  end

  def to_recipients=(val)
    super(normalized_email_addresses(val))
  end

  def cc_recipients=(val)
    super(normalized_email_addresses(val))
  end

  def bcc_recipients=(val)
    super(normalized_email_addresses(val))
  end

  def csv
    ([output.columns] + output.rows).map(&:to_csv).join
  end

  def output
    @output ||= ReportRecord.select_all(database, query)
  end

  def filename
    "#{sanitized_name} #{Time.now.utc.strftime('%Y-%m-%d %H_%M_%S')}.csv"
  end

  def sanitized_name
    name.chars.select { |char| FILENAME_CHARACTERS.include?(char) }.join
  end

  private

  def normalized_email_addresses(addresses)
    return addresses unless addresses.is_a?(String)

    addresses.split(',').map(&:strip)
  end

  def now
    @now ||= Time.now.utc
  end

  def normalized_schedule_time
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
