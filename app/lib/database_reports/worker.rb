# frozen_string_literal: true

module DatabaseReports
  # Background worker for generating email reports for scheduled queries.
  class Worker
    def work(once: false)
      log('worker.start')
      loop do
        process_reports
        break if once

        sleep 30
      end
    end

    private

    def process_reports
      Report.due.each do |report|
        log_export report:, export_context: 'scheduled_export'
        deliver_report(report)
      rescue *DatabaseReports::EXPECTED_DATABASE_ERRORS => e
        deliver_error(report, e)
      end
    end

    def log(entry, level = :info, **kwargs)
      Rails.logger.public_send(level, "[database_reports:worker] #{I18n.t(entry, **kwargs)}")

      nil
    end

    def deliver_report(report)
      ReportMailer.with(report:).report_mail.deliver_now
      report.update!(last_reported_at: Time.now.utc)
      log('worker.report', name: report.name, rows: report.output.rows.size)
    end

    def deliver_error(report, error)
      log('worker.error', :warn, name: report.name, error: error.message)
      return if report.failure_notified_since_success?

      ReportMailer.with(report:, error:).error_mail.deliver_now
      report.update!(failure_last_notified_at: Time.now.utc)
    end

    def log_export(report:, export_context:)
      ReportExport.create!(report:, export_context:, user: report.user, data: report_data(report))
    end

    def report_data(report)
      { columns: report.output.columns.map { |column| { name: column } }, rows: report.output.rows }
    end
  end
end
