# frozen_string_literal: true

RSpec.describe '/reports' do
  let(:user) { create(:user) }

  before { sign_in user }

  describe 'POST /reports' do
    it 'creates a new report' do
      post '/reports', params: {
        report: {
          name: 'my new report',
          subject: 'my subject',
          query: 'query',
          schedule_type: 'none'
        }
      }
      get '/reports'
      expect(document.table('.reports')).to match_text 'my new report'
    end

    it 'converts email address strings to an array' do
      post '/reports', params: {
        report: {
          name: 'my new report',
          subject: 'my subject',
          query: 'query',
          schedule_type: 'none',
          to_recipients: 'user1@example.com, user2@example.com'
        }
      }
      expect(Report.first.to_recipients).to eql %w[user1@example.com user2@example.com]
    end

    it 'translates schedule time' do
      post '/reports', params: {
        report: {
          name: 'my new report',
          subject: 'my subject',
          query: 'query',
          schedule_type: 'daily',
          schedule_time: '14:30',
          to_recipients: 'user1@example.com, user2@example.com'
        }
      }
      report = Report.first.schedule_time
      expect([report.hour, report.min]).to eql [14, 30]
    end
  end

  describe 'GET /reports' do
    it 'shows list of reports' do
      create(:report, user:)
      get '/reports'
      expect(document.table('.reports')).to match_text 'my report'
    end

    it "excludes other user's reports" do
      create(:report, user: create(:user))
      get '/reports'
      expect(document.table('.reports')).to_not match_text 'my report'
    end

    context 'admin user' do
      let(:user) { create(:user, admin: true) }

      it "shows all users' reports" do
        create_list(:report, 4)
        get '/reports'
        expect(document.table('.reports').tr('.report').size).to eql 4
      end

      it "displays report owner's username" do
        create(:report, user: create(:user, email: 'other-user@example.com'))
        get '/reports'
        expect(document.table('.reports').tr('.report')).to match_text 'other-user@example.com'
      end
    end
  end

  describe 'GET /reports/:id' do
    it 'shows a report' do
      report = create(:report, user:)
      get "/reports/#{report.id}"
      expect(document.div('.report')).to match_text 'my report'
    end

    context 'admin user' do
      let(:user) { create(:user, admin: true) }

      it "shows all users' reports" do
        report = create(:report)
        get "/reports/#{report.id}"
        expect(document.div('.report')).to match_text 'my report'
      end
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
      report = create(:report, user:)
      get "/reports/#{report.id}/edit"
      expect(document.form('.report').input(name: 'report[name]', value: 'my report')).to exist
    end

    it "does not edit other user's reports" do
      report = create(:report, user: create(:user))
      get "/reports/#{report.id}/edit"
      expect(document).to match_text 'you are not authorized to access'
    end

    context 'admin user' do
      let(:user) { create(:user, admin: true) }

      it 'shows a form for editing a report' do
        report = create(:report)
        get "/reports/#{report.id}/edit"
        expect(document.form('.report').input(name: 'report[name]', value: 'my report')).to exist
      end
    end
  end

  describe 'PATCH /reports/:id' do
    it 'updates an existing report' do
      report = create(:report, user:)
      patch "/reports/#{report.id}", params: { report: { name: 'my edited report' } }
      expect(report.reload.name).to eql 'my edited report'
    end

    it 'renders show page' do
      report = create(:report, user:)
      patch "/reports/#{report.id}", params: { report: { name: 'my edited report' } }
      expect(document).to match_text 'Report Name: my edited report'
    end

    it "rejects access to other user's reports" do
      report = create(:report, user: create(:user))
      patch "/reports/#{report.id}", params: { report: { name: 'my edited report' } }
      expect(document).to match_text 'you are not authorized to access'
    end

    context 'admin user' do
      let(:user) { create(:user, admin: true) }

      it 'updates an existing report' do
        report = create(:report)
        patch "/reports/#{report.id}", params: { report: { name: 'my edited report' } }
        expect(report.reload.name).to eql 'my edited report'
      end
    end
  end

  describe 'GET /reports/:id/view' do
    before { create(:example_report_data) }

    it 'shows report output columns' do
      report = create(:report, user:)
      get "/reports/#{report.id}/view"
      expect(document.table('.report-view')).to match_text 'example column'
    end

    it 'shows report output values' do
      report = create(:report, user:)
      get "/reports/#{report.id}/view"
      expect(document.table('.report-view')).to match_text 'example value'
    end

    it "rejects access to other user's reports" do
      report = create(:report, user: create(:user))
      get "/reports/#{report.id}/view"
      expect(document).to match_text 'you are not authorized to access'
    end

    context 'admin user' do
      let(:user) { create(:user, admin: true) }

      it 'shows report output values' do
        report = create(:report)
        get "/reports/#{report.id}/view"
        expect(document.table('.report-view')).to match_text 'example value'
      end
    end
  end

  describe 'GET /reports/:id/export' do
    let!(:report) { create(:report, user:) }
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

    context "other user's report" do
      let!(:report) { create(:report, user: create(:user)) }

      it 'rejects access' do
        expect(document).to match_text 'you are not authorized to access'
      end
    end

    context 'admin user' do
      let(:user) { create(:user, admin: true) }
      let!(:report) { create(:report) }

      it 'shows report output values' do
        expect(csv.last.first).to eql 'example value'
      end
    end
  end

  describe 'GET /reports/:id/email' do
    let!(:report) { create(:report, user:) }
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

    context "other user's report" do
      let!(:report) { create(:report, user: create(:user)) }

      it 'rejects access' do
        expect(document).to match_text 'you are not authorized to access'
      end
    end

    context 'admin user' do
      let(:user) { create(:user, admin: true) }
      let!(:report) { create(:report) }

      it 'shows report output values' do
        parse_html(mail.html_part.decoded)
        expect(document.table('.report-view').td).to match_text 'example value'
      end
    end
  end

  describe 'DELETE /reports/:id' do
    let!(:report) { create(:report, user:) }

    it 'deletes report' do
      delete "/reports/#{report.id}"

      expect(report.reload).to be_deleted
    end

    it 'renders index' do
      delete "/reports/#{report.id}"

      expect(document.h1).to match_text 'Reports'
    end

    context 'admin user' do
      let(:user) { create(:user, admin: true) }
      let!(:report) { create(:report) }

      it 'deletes report' do
        delete "/reports/#{report.id}"

        expect(report.reload).to be_deleted
      end
    end
  end
end
