# frozen_string_literal: true

RSpec.describe '/reports' do
  describe 'POST /reports' do
    it 'creates a new report' do
      post '/reports', params: { report: { name: 'my new report', subject: 'my subject', query: 'query' } }
      get '/reports'
      expect(document.table('.reports')).to match_text 'my new report'
    end

    it 'redirects to show page' do
      post '/reports', params: { report: { name: 'my new report', subject: 'my subject', query: 'query' } }
      expect(response).to redirect_to "/reports/#{Report.first.id}"
    end

    it 'converts email address strings to an array' do
      post '/reports', params: {
        report: {
          name: 'my new report',
          subject: 'my subject',
          query: 'query',
          to_recipients: 'user1@example.com, user2@example.com'
        }
      }
      expect(Report.first.to_recipients).to eql %w[user1@example.com user2@example.com]
    end
  end

  describe 'GET /reports' do
    it 'shows list of reports' do
      create(:report)
      get '/reports'
      expect(document.table('.reports')).to match_text 'my report'
    end
  end

  describe 'GET /reports/:id' do
    it 'shows a report' do
      report = create(:report)
      get "/reports/#{report.id}"
      expect(document.div('.report')).to match_text 'my report'
    end
  end

  describe 'GET /reports/new' do
    it 'shows a form for generating a report' do
      get '/reports/new'
      expect(document.form('.report').input(name: 'report[name]')).to exist
    end
  end

  describe 'GET /reports/:id/edit' do
    it 'shows a form for editing a report' do
      report = create(:report)
      get "/reports/#{report.id}/edit"
      expect(document.form('.report').input(name: 'report[name]', value: 'my report')).to exist
    end
  end

  describe 'PATCH /reports/:id' do
    it 'updates an existing report' do
      report = create(:report)
      patch "/reports/#{report.id}", params: { report: { name: 'my edited report' } }
      expect(report.reload.name).to eql 'my edited report'
    end

    it 'redirects to show page' do
      report = create(:report)
      patch "/reports/#{report.id}", params: { report: { name: 'my edited report' } }
      expect(response).to redirect_to "/reports/#{report.id}"
    end
  end

  describe 'GET /reports/:id/view' do
    let!(:report) { create(:report) }

    before { create(:example_report_data) }

    it 'shows report output columns' do
      get "/reports/#{report.id}/view"
      expect(document.table('.report-view')).to match_text 'example column'
    end

    it 'shows report output values' do
      get "/reports/#{report.id}/view"
      expect(document.table('.report-view')).to match_text 'example value'
    end
  end

  describe 'GET /reports/:id/export' do
    let!(:report) { create(:report) }
    let(:csv) { CSV.parse(response.body) }

    before { travel_to(Time.new(2022, 5, 28, 16, 13, 47)) }
    before { create(:example_report_data) }
    before { get "/reports/#{report.id}/export" }

    it 'shows report output columns' do
      expect(csv.first.first).to eql 'example column'
    end

    it 'shows report output values' do
      expect(csv.last.first).to eql 'example value'
    end

    it 'generates filename' do
      expect(response.headers['content-disposition']).to include 'filename="my report 2022-05-28 15_13_47.csv";'
    end
  end

  describe 'GET /reports/:id/email' do
    let!(:report) { create(:report) }
    let(:mail) { ActionMailer::Base.deliveries.last }

    before { create(:example_report_data) }
    before { get "/reports/#{report.id}/email" }

    it 'emails report' do
      parse_html(mail.html_part.decoded)
      expect(document.table('.report-view').td).to match_text 'example value'
    end

    it 'attaches csv report' do
      csv = CSV.parse(mail.attachments.first.body.decoded)
      expect(csv.last).to eql ['example value']
    end

    it 'displays confirmation flash message' do
      expect(document.div('.flash.notice')).to match_text 'Report delivered to to@example.com'
    end
  end
end
