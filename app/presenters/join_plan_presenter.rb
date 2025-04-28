# frozen_string_literal: true

class JoinPlanPresenter
  include ActionView::Helpers::NumberHelper

  Plan = Struct.new(:id, :nickname, :price)
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
        nickname: plan.nickname,
        price: number_to_currency(plan.amount / 100.0, unit: '£')
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
end
