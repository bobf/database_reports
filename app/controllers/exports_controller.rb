# frozen_string_literal: true

# Access to previous saved exports of a report query.
class ExportsController < ApplicationController
  include ReportsConcern

  before_action :authorize_report_owner
  rescue_from ActiveRecord::RecordNotFound, with: :report_not_found

  def index
    @report = report
    @exports = ReportExport.where(report:).order(created_at: :desc)
  end

  def show
    @report = report
    @export = ReportExport.find_by(report:, id: params[:id])
    @output = @export
    @generated_at = @export.created_at
  end

  def export
    @export = ReportExport.find_by(report:, id: params[:id])
    send_data @export.csv, type: 'text/csv', disposition: 'attachment', filename: @export.filename
  rescue *database_errors => e
    @error = e.message
    render :show
  end

  private

  def report
    @report ||= Report.find(params[:report_id])
  end
end
