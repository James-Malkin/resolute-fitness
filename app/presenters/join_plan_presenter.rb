# frozen_string_literal: true

class JoinPlanPresenter
  include ActionView::Helpers::NumberHelper

  PlanFeatures = Struct.new(:time_restriction, :peak_bookings, :book_in_advance)
  Plan = Struct.new(:id, :display_colour, :name, :description, :price, :features)

  PaymentMethod = Struct.new(:id, :brand, :last4, :exp_month, :exp_year)

  def initialize(member)
    @member = member
  end

  def member_has_a_plan?
    @member.plan != 'guest'
  end

  def member_payment_methods
    Stripe::PaymentMethod.list(
      customer: @member.stripe_customer_id,
      type: 'card'
    ).map do |payment_method|
      build_payment_method(payment_method)
    end
  end

  def formatted_plans
    Stripe::Plans.all.map do |plan|
      Plan.new(
        id: plan.id,
        display_colour: plan.metadata[:display_colour],
        name: plan.nickname,
        description: plan.metadata[:description],
        price: number_to_currency(plan.amount / 100.0, unit: '£'),
        features: build_plan_features(plan.metadata)
      )
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

  def build_plan_features(metadata)
    PlanFeatures.new(
      time_restriction: metadata[:time_restriction],
      peak_bookings: format_peak_bookings(metadata[:peak_bookings]),
      book_in_advance: "#{metadata[:book_in_advance]} days"
    )
  end

  def format_peak_bookings(peak_bookings)
    case peak_bookings
    when nil
      { type: :icon, value: 'infinity', label: 'Unlimited' }
    when 0
      { type: :icon, value: 'minus', label: 'None' }
    else
      { type: :text, value: "#{peak_bookings} #{'booking'.pluralize(peak_bookings)}" }
    end
  end
end
