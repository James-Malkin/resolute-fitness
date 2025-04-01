# frozen_string_literal: true

class DeviseBootstrapMailer < Devise::Mailer
  layout 'bootstrap-mailer'

  def devise_mail(record, action, opts = {}, &)
    initialize_from_record(record)
    bootstrap_mail(headers_for(action, opts), &)
  end
end
