# frozen_string_literal: true

namespace :reports do
  desc 'Process reports in the background'
  task worker: :environment do
    DatabaseReports::Worker.new.work
  end
end
