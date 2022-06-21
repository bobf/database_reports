# frozen_string_literal: true

# CRUD actions for database reports.
class ReportsController < ApplicationController
  include ReportsConcern

  before_action :authorize_report_owner, except: %i[new index create]
  rescue_from ActiveRecord::RecordNotFound, with: :report_not_found

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
    if @report.update(report_params.merge(last_edited_by: current_user, last_edited_at: Time.now.utc))
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
    log_export :web_view
    @report = report
    @output = report.output
  rescue *database_errors => e
    @error = e.message
  end

  def export
    log_export :web_export
    send_data report.csv, type: 'text/csv', disposition: 'attachment', filename: report.filename
  rescue *database_errors => e
    @error = e.message
    render :view
  end

  def email
    log_export :web_email
    @report = report
    ReportMailer.with(report: @report).report_mail.deliver_now
    flash[:notice] = "Report delivered to #{@report.to_recipients.join(', ')} &check;"
    render :show
  rescue *database_errors => e
    @error = e.message
    render :view
  end

  private

  def report
    @report ||= Report.find(params[:id])
  end

  def log_export(export_context)
    ReportExport.create!(report:, export_context:, user: current_user, data: report_data)
  end

  def report_data
    { columns: report.output.columns.map { |column| { name: column } }, rows: report.output.rows }
  end
end
