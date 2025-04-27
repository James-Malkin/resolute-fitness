# frozen_string_literal: true

module StripeManager
  class Customer
    def self.create(member)
      return if member.stripe_customer_id?

      stripe_customer = Stripe::Customer.create(
        email: member.email,
        metadata: {
          member_id: member.id
        }
      )

      member.update!(stripe_customer_id: stripe_customer.id)
    end
  end
end
