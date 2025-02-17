begin
  require "slim_lint/rake_task"

  SlimLint::RakeTask.new do |task|
    task.files = [ "app/views" ]
  end

  task slim_lint_accounce: :environment do
    RakeAnnouncer.log_step "Running Slim-Lint..."
  end

  task slim_lint: :slim_lint_accounce
rescue LoadError
  desc "Slim-Lint is not available."
  task slim_lint: :environment do
    abort "Slim-Lint is not available."
  end
end
