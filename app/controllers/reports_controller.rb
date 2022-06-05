# frozen_string_literal: true

# CRUD actions for database reports.
class ReportsController < ApplicationController
  before_action :authorize_report_owner, except: %i[new index create]
  rescue_from ActiveRecord::RecordNotFound, with: :report_not_found
  helper_method :current_reports

  def index; end

  def create
    @report = Report.new(user: current_user, **report_params)
    if @report.save
      render :show
    else
      render :new
    end
  end

  def show
    @report = report
  end

  def edit
    @report = report
  end

  def new
    @report = Report.new
  end

  def update
    @report = report
    if @report.update(report_params)
      render :show
    else
      render :edit
    end
  end

  def destroy
    report.destroy
    flash[:notice] = 'Report deleted.'
    render :index
  end

  def view
    @report = report
    @output = report.output
  rescue *database_errors => e
    @error = e.message
  end

  def export
    send_data report.csv, type: 'text/csv', disposition: 'attachment', filename: report.filename
  rescue *database_errors => e
    @error = e.message
    render :view
  end

  def email
    @report = report
    ReportMailer.with(report: @report).report_mail.deliver_now
    flash[:notice] = "Report delivered to #{@report.to_recipients.join(', ')} &check;"
    render :show
  rescue *database_errors => e
    @error = e.message
    render :view
  end

  def report_not_found
    render template: 'reports/not_found'
  end

  private

  def report
    @report ||= Report.find(params[:id])
  end

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
            :schedule_day, :schedule_time, :schedule_type
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
end
