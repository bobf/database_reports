# frozen_string_literal: true

# Common methods used to access reports in ReportsController and ExportsController.
module ReportsConcern
  extend ActiveSupport::Concern

  included do
    helper_method :current_reports
  end

  private

  def current_reports
    @current_reports ||= if current_user.admin?
                           Report.all
                         else
                           current_user.reports
                         end.order(created_at: :desc)
  end

  def report_params
    params.require(:report)
          .permit(
            :name, :query, :to_recipients, :cc_recipients, :bcc_recipients, :subject,
            :schedule_day, :schedule_time, :schedule_type, :database_id
          )
  end

  def database_errors
    DatabaseReports::EXPECTED_DATABASE_ERRORS
  end

  def authorize_report_owner
    return if current_user&.admin?
    return if current_user.present? && report&.user == current_user

    report_not_found
  end

  def report_not_found
    render template: 'reports/not_found'
  end
end
