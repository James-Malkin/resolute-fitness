# frozen_string_literal: true

module StripeManager
  class Subscription
    def self.create(member, params)
      Stripe::Subscription.create(
        customer: member.stripe_customer_id,
        items: [
          { price: params[:price_id] }
        ],
        default_payment_method: params[:payment_method_id]
      )
    rescue Stripe::CardError => e
      Rails.logger.error("Stripe CardError: #{e.message}")
    end
  end
end
