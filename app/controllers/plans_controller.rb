# frozen_string_literal: true

class PlansController < ApplicationController
  def index
    @join_presenter = JoinPlanPresenter.new(current_user)
    @payment_methods = PaymentMethodsPresenter.for_user(current_user)
  end
end
