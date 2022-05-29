# frozen_string_literal: true

RSpec.describe DatabaseReports::Worker do
  it { is_expected.to be_a described_class }

  describe '#work' do
    let(:mail) { ActionMailer::Base.deliveries.last }
    let(:now) { Time.now.utc }

    it 'dispatches weekly scheduled jobs' do
      create(:report, schedule_type: 'weekly', schedule_day: now.wday, schedule_time: now)
      create(:example_report_data)
      subject.work(once: true)
      parse_html(mail.html_part.decoded)
      expect(document.table('.report-view').td).to match_text 'example value'
    end

    it 'dispatches daily scheduled jobs' do
      create(:report, schedule_type: 'daily', schedule_time: now)
      create(:example_report_data)
      subject.work(once: true)
      parse_html(mail.html_part.decoded)
      expect(document.table('.report-view').td).to match_text 'example value'
    end

    it 'does not dispatch not-due weekly scheduled jobs' do
      create(:report, schedule_type: 'weekly', schedule_day: now.wday + 1, schedule_time: now)
      create(:example_report_data)
      subject.work(once: true)
      expect(mail).to be_blank
    end

    it 'does not dispatch not-due daily scheduled jobs' do
      create(:report, schedule_type: 'daily', schedule_time: now + 1.hour)
      create(:example_report_data)
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
  end
end
