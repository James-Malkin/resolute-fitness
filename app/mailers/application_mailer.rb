# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'no-reply@resolutefitness.studio'
  layout 'bootstrap-mailer'

  def devise_mail(record, action, opts = {}, &block)
    initialize_from_record(record)
    bootstrap_mail headers_for(action, opts), &block
  end
end
