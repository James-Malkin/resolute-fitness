# frozen_string_literal: true

class PaymentMethodsPresenter
  PaymentMethod = Struct.new(:id, :brand, :last4, :exp_month, :exp_year)

  def self.for_user(user)
    return [] unless user.member

    new.for_user(user.member)
  end

  def for_user(member)
    Stripe::PaymentMethod.list(
      customer: member.stripe_customer_id,
      type: 'card'
    ).map do |payment_method|
      build_payment_method(payment_method)
    end
  end

  private

  def build_payment_method(payment_method)
    PaymentMethod.new(
      id: payment_method.id,
      brand: payment_method.card.brand,
      last4: payment_method.card.last4,
      exp_month: payment_method.card.exp_month,
      exp_year: payment_method.card.exp_year
    )
  end
end
