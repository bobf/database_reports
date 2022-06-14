# frozen_string_literal: true

# Base class used for executing report queries on target database.
class ReportRecord < ActiveRecord::Base
  self.abstract_class = true

  class << self
    def select_all(database, query)
      establish_connection(database.to_h)
      connection.reconnect!
      connection.select_all(query)
    end

    def database_tables(database)
      establish_connection(database.to_h)
      connection.reconnect!
      connection.tables.to_h do |table|
        [table, { columns: database_columns(table) }]
      end
    end

    private

    def database_columns(table)
      connection.columns(table).map do |column|
        { name: column.name, type: column.type }
      end
    end
  end
end
