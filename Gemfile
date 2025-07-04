# frozen_string_literal: true

source 'https://rubygems.org'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 8.0.1'
# The modern asset pipeline for Rails [https://github.com/rails/propshaft]
gem 'propshaft'
# Use PostgreSQL as the database for Active Record
# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '>= 5.0'
# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem 'importmap-rails'
# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem 'turbo-rails'
# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem 'stimulus-rails'
# Use Tailwind CSS [https://github.com/rails/tailwindcss-rails]
gem 'tailwindcss-rails', '~> 4.0'
# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem 'jbuilder'

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[windows jruby]

# Use the database-backed adapters for Rails.cache, Active Job, and Action Cable
gem 'solid_cable'
gem 'solid_cache'
gem 'solid_queue'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Deploy this application anywhere as a Docker container [https://kamal-deploy.org]
gem 'kamal', require: false

# Add HTTP asset caching/compression and X-Sendfile acceleration to Puma [https://github.com/basecamp/thruster/]
gem 'thruster', require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

group :development, :test do
  gem 'brakeman', require: false
  gem 'debug', platforms: %i[mri windows], require: 'debug/prelude'

  gem 'dotenv-rails'
  gem 'factory_bot_rails'
  gem 'faker', '~> 3.5'
  gem 'rails_best_practices-rake_task', '~> 1.0'
  gem 'rubocop'
  gem 'rubocop-capybara'
  gem 'rubocop-performance', require: false
  gem 'slim_lint', '~> 0.31.1'
  gem 'term-ansicolor', '~> 1.11'
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem 'letter_opener_web'
  gem 'web-console'
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem 'capybara'
  gem 'capybara-screenshot'
  gem 'cuprite'
  gem 'database_cleaner-active_record'
  gem 'rspec-rails', '~> 7.1'
  gem 'shoulda-matchers'
  gem 'simplecov'
  gem 'simplecov-cobertura'
end

gem 'slim-rails'

gem 'tailwindcss-ruby', '~> 4.0'

gem 'pg', '~> 1.5'

gem 'devise', '~> 4.9'

gem 'bootstrap-email'

gem 'lucide-rails', '~> 0.5.1'

gem 'active_storage_validations'
gem 'image_processing', '~> 1.2'

gem 'cancancan', '~> 3.6'
gem 'delayed_job_active_record'
gem 'kaminari'
gem 'sentry-rails'
gem 'sentry-ruby'
gem 'stripe'
gem 'stripe-rails', '~> 2.6'
