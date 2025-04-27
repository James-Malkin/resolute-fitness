# frozen_string_literal: true

module StripeManager
  class Customer
    def self.create(user)
      return if user.member.nil? || user.member.stripe_customer_id.present?
      
      stripe_customer = Stripe::Customer.create(
        email: user.email,
        metadata: {
          user_id: user.id
        }
      )
  
      user.member.update!(stripe_customer_id: stripe_customer.id)
    end
  end
end