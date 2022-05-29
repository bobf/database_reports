# frozen_string_literal: true

RSpec.describe Report do
  describe '.due' do
    subject(:due) { described_class.due }

    let(:now) { Time.now.utc }

    let!(:report_daily_never_reported) do
      create(
        :report,
        schedule_type: 'daily',
        schedule_time: now,
        last_reported_at: nil
      )
    end

    let!(:report_daily_reported_since_scheduled_time) do
      create(
        :report,
        schedule_type: 'daily',
        schedule_time: now - 5.minutes,
        last_reported_at: now
      )
    end

    let!(:report_daily_reported_yesterday) do
      create(
        :report,
        schedule_type: 'daily',
        schedule_time: now,
        last_reported_at: now - 1.day
      )
    end

    let!(:report_weekly_reported_today) do
      create(
        :report,
        schedule_type: 'weekly',
        schedule_day: now.wday,
        schedule_time: now - 5.minutes,
        last_reported_at: now
      )
    end

    let!(:report_weekly_reported_last_week) do
      create(
        :report,
        schedule_type: 'weekly',
        schedule_day: now.wday,
        schedule_time: now - 5.minutes,
        last_reported_at: now - 1.week
      )
    end

    let!(:report_weekly_never_reported) do
      create(
        :report,
        schedule_type: 'weekly',
        schedule_day: now.wday,
        schedule_time: now - 5.minutes,
        last_reported_at: nil
      )
    end

    it { is_expected.to include report_daily_reported_yesterday }
    it { is_expected.to include report_daily_never_reported }
    it { is_expected.to include report_weekly_reported_last_week }
    it { is_expected.to include report_weekly_never_reported }
    it { is_expected.to_not include report_daily_reported_since_scheduled_time }
    it { is_expected.to_not include report_weekly_reported_today }
  end
end
