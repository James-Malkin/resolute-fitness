# frozen_string_literal: true

module StripeManager
  class Webhooks
    def self.build_event(request)
      payload = request.body.read
      sig_header = request.headers['HTTP_STRIPE_SIGNATURE']

      Stripe::Webhook.construct_event(payload, sig_header, ENV.fetch('STRIPE_WEBHOOK_SECRET', nil))
    end

    def self.route_event(event)
      case event.type
      when 'payment_intent.succeeded'
        puts 'PaymentIntent was successful!'
      when 'payment_intent.payment_failed'
        puts 'PaymentIntent failed!'
      end
    end
  end
end
