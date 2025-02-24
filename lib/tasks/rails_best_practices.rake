# frozen_string_literal: true

begin
  require 'rails_best_practices/rake_task'
  RailsBestPractices::RakeTask.new

  task rails_best_practices_accounce: :environment do
    RakeAnnouncer.log_step 'Running Rails Best Practices...'
  end

  task rails_best_practices: :rails_best_practices_accounce
rescue LoadError
  desc 'Rails Best Practices is not available.'
  task rails_best_practices: :environment do
    abort 'Rails Best Practices is not available.'
  end
end
