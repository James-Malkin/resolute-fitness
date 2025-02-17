# require 'rake_accouncer'

Rake::Task[:default].prerequisites.clear if Rake::Task.task_defined?(:default)

task default: %i[
  checks
]
