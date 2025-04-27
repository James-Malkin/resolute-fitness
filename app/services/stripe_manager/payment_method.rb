# frozen_string_literal: true

module StripeManager
  class PaymentMethod
    def self.attach(member, payment_method_id)
      Stripe::PaymentMethod.attach(
        payment_method_id,
        {
          customer: member.stripe_customer_id
        }
      )
    end
  end
end
