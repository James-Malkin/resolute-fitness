# frozen_string_literal: true

module StripeManager
  class PaymentIntent
    def self.create(member, booking)
      new.create(member, booking)
    end

    def create(member, booking)
      payment_intent = build_payment_intent(member, booking)

      booking.update!(payment_status: :pending, payment_intent_id: payment_intent.id)

      payment_intent
    end

    private

    def build_payment_intent(member, booking)
      Stripe::PaymentIntent.create(
        amount: (booking.class_schedule.price * 100).to_i,
        currency: 'gbp',
        payment_method_types: ['card'],
        customer: member.stripe_customer_id,
        metadata: {
          member_id: member.id,
          booking_id: booking.id
        }
      )
    end
  end
end
