# frozen_string_literal: true

begin
  require 'rubocop/rake_task'

  RuboCop::RakeTask.new do |task|
    task.options = ['--parallel']
  end

  task rubocop_accounce: :environment do
    RakeAnnouncer.log_step('Running RuboCop...')
  end

  task rubocop: :rubocop_accounce
rescue LoadError
  desc 'RuboCop is not available.'
  task rubocop: :environment do
    abort 'RuboCop is not available.'
  end
end
