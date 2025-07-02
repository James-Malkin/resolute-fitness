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

  def build_plan(id: 'bronze', amount: 1000, currency: 'gbp', interval: 'month', interval_count: 1, peak_bookings: nil)
    Stripe::Plan.construct_from(
      id:,
      amount:,
      currency:,
      interval:,
      interval_count:,
      metadata: {
        display_colour: '#000000',
        description: 'Test Plan Description',
        book_in_advance: 7,
        plan_type: 'basic',
        time_restriction: 'off_peak',
        peak_bookings:
      }
    )
  end

  def build_payment_intent(id: 'pi_test_123', client_secret: 'pi_test_123_secret_test', status: 'requires_payment_method')
    Stripe::PaymentIntent.construct_from(
      id:,
      client_secret:,
      status:
    )
  end

  def build_subscription(id: 'sub_test_123', default_payment_method: 'pm_123')
    Stripe::Subscription.construct_from(
      id:,
      default_payment_method:,
      items: {
        data: [build_subscription_item]
      },
      plan: build_plan
    )
  end

  private

  def build_subscription_item
    Stripe::SubscriptionItem.construct_from(
      current_period_end: 1.day.from_now.to_i
    )
  end
end
