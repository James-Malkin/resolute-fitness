# frozen_string_literal: true

class PaymentMethodsController < ApplicationController
  def new; end

  def create
    StripeManager::PaymentMethod.attach(current_user.member, payment_method_params[:payment_method_id])

    redirect_to request.referer || profile_edit_path, notice: 'Payment method added successfully.'
  end

  private

  def payment_method_params
    params.permit(:payment_method_id)
  end
end
