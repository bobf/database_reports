# frozen_string_literal: true

# Base class used for executing report queries on target database.
class ReportRecord < ActiveRecord::Base
  self.abstract_class = true
  establish_connection(Rails.application.config_for('database.reports'))
end
