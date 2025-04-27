# frozen_string_literal: true

class MembersController < ApplicationController

  def subscribe
    StripeManager::Subscription.create(current_user, subscribe_params)
  end

  private

  def subscribe_params
    params.require(:member).permit(:price_id, :payment_method_id)
  end

end