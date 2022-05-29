# frozen_string_literal: true

# Database query report emailer.
class ReportMailer < ApplicationMailer
  default from: ENV.fetch('MAILER_FROM_ADDRESS', 'no-reply@example.com')

  def report_mail
    @report = params[:report]
    @output = @report.output
    attachments[@report.filename] = @report.csv
    mail(
      to: @report.to_recipients,
      cc: @report.cc_recipients,
      bcc: @report.bcc_recipients,
      subject: @report.subject
    )
  end
end
