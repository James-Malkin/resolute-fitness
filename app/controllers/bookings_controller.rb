# frozen_string_literal: true

class BookingsController < ApplicationController
  def new
    redirect_to root_path and return if request.headers['Turbo-Frame'].blank?

    @booking = Booking.new(class_schedule_id: params[:class_schedule_id])
  end

  def pay
    # @booking = Booking.new(booking_params)
    @booking = Booking.find(params[:id])

    # payment_intent = StripeManager::PaymentIntent.create(current_user.member, @booking.class_schedule)
  end

  def create
    @booking = Booking.new(booking_params)
    if @booking.save
      # redirect_to bookings_path, notice: 'Booking created successfully.'
      redirect_to pay_booking_path(@booking)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def booking_params
    params.require(:booking).permit(:class_schedule_id).merge(member_id: current_user.member.id)
  end
end
