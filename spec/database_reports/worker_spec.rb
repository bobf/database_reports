# frozen_string_literal: true

RSpec.describe DatabaseReports::Worker do
  it { is_expected.to be_a described_class }

  describe '#work' do
    let(:mail) { ActionMailer::Base.deliveries.last }
    let(:now) { Time.now.utc }

    it 'dispatches weekly scheduled jobs' do
      create(:report, schedule_type: 'weekly', schedule_day: now.wday, schedule_time: now)
      subject.work(once: true)
      parse_html(mail.html_part.decoded)
      expect(document.table('.report-view').td).to match_text 'example value'
    end

    it 'dispatches daily scheduled jobs' do
      create(:report, schedule_type: 'daily', schedule_time: now)
      subject.work(once: true)
      parse_html(mail.html_part.decoded)
      expect(document.table('.report-view').td).to match_text 'example value'
    end

    it 'does not dispatch not-due weekly scheduled jobs' do
      create(:report, schedule_type: 'weekly', schedule_day: now.wday + 1, schedule_time: now)
      subject.work(once: true)
      expect(mail).to be_blank
    end

    it 'does not dispatch not-due daily scheduled jobs' do
      create(:report, schedule_type: 'daily', schedule_time: now + 1.hour)
      subject.work(once: true)
      expect(mail).to be_blank
    end

    it 'sets report#last_reported_at to current time' do
      freeze_time
      report = create(:report, schedule_type: 'daily', schedule_time: now)
      subject.work(once: true)
      expect(report.reload.last_reported_at).to eql now
    end

    it 'delivers error email on query failure' do
      create(:report, schedule_type: 'weekly', schedule_day: now.wday, schedule_time: now, query: 'bad query')
      subject.work(once: true)
      parse_html(mail.html_part.decoded)
      expect(document.div('.error')).to match_text 'syntax error at or near "bad"'
    end

    it 'only delivers one error email per failure since last delivery [failure, failure]' do
      create(:report, schedule_type: 'weekly', schedule_day: now.wday, schedule_time: now, query: 'bad query')
      subject.work(once: true)
      subject.work(once: true)
      expect(ActionMailer::Base.deliveries.size).to eql 1
    end

    it 'only delivers one error email per failure since last delivery [failure, success, failure]' do
      # FIXME: Make this test less horrific.
      create(:report, schedule_type: 'weekly', schedule_day: now.wday, schedule_time: now)
      allow_any_instance_of(Report).to receive(:output) { raise ActiveRecord::StatementInvalid }
      allow_any_instance_of(Report).to receive(:last_reported_at) { nil }
      allow_any_instance_of(Report).to receive(:failure_last_notified_at) { nil }
      subject.work(once: true)
      allow_any_instance_of(Report).to receive(:output) { double(columns: [], rows: []) }
      allow_any_instance_of(Report).to receive(:last_reported_at) { nil }
      allow_any_instance_of(Report).to receive(:failure_last_notified_at) { Time.now.utc }
      subject.work(once: true)
      allow_any_instance_of(Report).to receive(:output) { raise ActiveRecord::StatementInvalid }
      allow_any_instance_of(Report).to receive(:last_reported_at) { Time.now.utc - 1.minute }
      subject.work(once: true)
      expect(ActionMailer::Base.deliveries.size).to eql 3
    end
  end
end
