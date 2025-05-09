# frozen_string_literal: true

class PaymentsController < ApplicationController
  def create
    booking = Booking.find(params[:booking_id])

    payment_intent = StripeManager::PaymentIntent.create(current_user.member, booking)

    render json: {
      client_secret: payment_intent.client_secret,
      payment_intent_id: payment_intent.id
    }
  end
end
