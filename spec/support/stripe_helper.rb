# frozen_string_literal: true

module StripeHelper
  def build_payment_method(id: 'pm_123', brand: 'Visa', last4: '1234', exp_month: 12, exp_year: 2050)
    Stripe::PaymentMethod.construct_from(
      id: id,
      card: {
        brand: brand,
        last4: last4,
        exp_month: exp_month,
        exp_year: exp_year
      }
    )
  end

  def build_plan(id: 'price_123', nickname: 'Basic Plan', amount: 1000, currency: 'gbp', interval: 'month', interval_count: 1)
    Stripe::Plan.construct_from(
      id: id,
      nickname: nickname,
      amount: amount,
      currency: currency,
      interval: interval,
      interval_count: interval_count,
      metadata: {
        display_colour: '#000000',
        description: 'Basic Plan Description',
        book_in_advance: 7,
        plan_type: 'basic',
        time_restriction: "off_peak"
      }
    )
  end
end
