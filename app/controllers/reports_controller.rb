# frozen_string_literal: true

# CRUD actions for database reports.
class ReportsController < ApplicationController
  def index
    @reports = Report.all
  end

  def create
    @report = Report.new(report_params)
    if @report.save
      redirect_to report_path(@report)
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
    report.update!(report_params)
    redirect_to report_path(report)
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

  private

  def report
    @report ||= Report.find(params[:id])
  end

  def report_params
    params.require(:report)
          .permit(:name, :query, :to_recipients, :cc_recipients, :bcc_recipients, :subject)
  end

  def database_errors
    [ActiveRecord::StatementInvalid, ActiveRecord::DatabaseConnectionError]
  end
end
