# frozen_string_literal: true

Sentry.init do |config|
  config.dsn = Rails.application.credentials[:sentry_dsn]
  config.breadcrumbs_logger = %i[active_support_logger http_logger]

  config.send_default_pii = true

  config.traces_sample_rate = 0.5
  config.traces_sampler = lambda do |_context|
    true
  end
end
