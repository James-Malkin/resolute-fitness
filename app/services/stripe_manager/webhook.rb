# frozen_string_literal: true

module StripeManager
  class Webhook
    def self.build_event(request)
      payload = request.body.read
      signature_header = request.headers['HTTP_STRIPE_SIGNATURE']

      Stripe::Webhook.construct_event(payload, signature_header, ENV.fetch('STRIPE_WEBHOOK_SECRET', nil))
    end

    def self.route_event(event)
      case event.type
      when 'payment_intent.succeeded'
        Booking.find_by(payment_intent_id: event.data.object.id).update!(payment_status: :succeeded)
      when 'payment_intent.payment_failed'
        Booking.find_by(payment_intent_id: event.data.object.id).update!(payment_status: :failed)
      end
    end
  end
end
