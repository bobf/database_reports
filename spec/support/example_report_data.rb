# frozen_string_literal: true

# Example report data record used for testing query output.
class ExampleReportData < ReportRecord
  establish_connection(Rails.application.config_for('database.reports'))
  self.table_name = 'example_table'
end
