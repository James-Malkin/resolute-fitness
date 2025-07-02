# frozen_string_literal: true

require 'capybara/cuprite'
require 'capybara-screenshot/rspec'

Capybara.register_driver(:cuprite_custom) do |app|
  Capybara::Cuprite::Driver.new(app,
                                headless: true,
                                js_errors: true,
                                window_size: [1600, 1200],
                                process_timeout: 10,
                                inspector: true,
                                browser_options: {
                                  'no-sandbox': nil,
                                  'disable-gpu': true,
                                  'disable-software-rasterizer': true,
                                  'disable-dev-shm-usage': true
                                })
end

Capybara::Screenshot.register_driver(:cuprite_custom) do |driver, path|
  driver.save_screenshot(path)
end

Capybara::Screenshot.prune_strategy = :keep_last_run

if ENV['CI']
  Capybara.server = :puma, { Silent: true }
  Capybara.default_max_wait_time = 10
end
