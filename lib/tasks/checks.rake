desc "Run various code quality checks"
task checks: %i[
  slim_lint
  rubocop
  rails_best_practices
  rspec
]
