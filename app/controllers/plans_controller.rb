# frozen_string_literal: true

class PlansController < ApplicationController
  before_action :authenticate_user!, only: [:join]

  def index; end

  def join
    @plans = Stripe::Plans.all
    @payment_methods = Stripe::PaymentMethod.list(
      customer: current_user.member.stripe_customer_id,
      type: 'card'
    )
  end
end
