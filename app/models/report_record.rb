# frozen_string_literal: true

# Base class used for executing report queries on target database.
class ReportRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.select_all(database, query)
    establish_connection(database.to_h)
    connection.reconnect!
    connection.select_all(query)
  end
end
