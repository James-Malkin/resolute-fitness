# frozen_string_literal: true

class MembersController < ApplicationController
  def subscribe
    StripeManager::Subscription.create(subscribe_params)
  end

  private

  def subscribe_params
    params.permit(:id, :price_id, :payment_method_id)
  end
end
