# frozen_string_literal: true

class JoinPlanPresenter
  include ActionView::Helpers::NumberHelper

  PlanFeatures = Struct.new(:time_restriction, :peak_bookings, :book_in_advance)
  Plan = Struct.new(:id, :display_colour, :description, :price, :features)

  def initialize(user)
    @member = user&.member
  end

  def member_has_a_plan?
    @member.plan != 'guest'
  end

  def formatted_plans
    Stripe::Plans.all.map do |plan|
      Plan.new(
        id: plan.id,
        display_colour: plan.metadata[:display_colour],
        description: plan.metadata[:description],
        price: number_to_currency(plan.amount / 100.0, unit: '£'),
        features: build_plan_features(plan.metadata)
      )
    end
  end

  private

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
