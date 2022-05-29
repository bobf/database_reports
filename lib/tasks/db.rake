# frozen_string_literal: true

namespace :db do
  namespace :reports do
    desc 'Drop reports database'
    task drop: :environment do
      ActiveRecord::Tasks::DatabaseTasks.drop(config)
    end

    desc 'Create reports database'
    task create: :environment do
      ActiveRecord::Tasks::DatabaseTasks.create(config)
    end

    desc 'Migrate reports database'
    task migrate: :environment do
      require Rails.root.join('db/migrate_reports/20220528140514_create_example_table.rb')
      ActiveRecord::Base.establish_connection(config)
      CreateExampleTable.new.change
    rescue PG::DuplicateTable => e
      warn e
    end
  end
end

def config
  Rails.application.config_for('database.reports')
end
