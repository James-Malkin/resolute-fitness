# frozen_string_literal: true

class BookingsController < ApplicationController
  def new
    redirect_to root_path and return if request.headers['Turbo-Frame'].blank?

    @booking = Booking.new(class_schedule_id: params[:class_schedule_id])

    @session_available = BookingEvaluator.session_availability(params[:class_schedule_id], current_user)

    @payment_required = BookingEvaluator.payment_required?(current_user || nil)
  end

  def pay
    @booking = Booking.find(params[:id])
  end

  def create
    status, @booking = BookingEvaluator.process_booking(booking_params, current_user)

    case status
    when :payment_required
      redirect_to pay_booking_path(@booking)
    when :payment_success
      redirect_to profile_show_path(current_user.username), notice: 'Booking created successfully.'
    else
      redirect_to new_booking_path(class_schedule_id: @booking.class_schedule_id)
    end
  end

  private

  def booking_params
    params.require(:booking).permit(:class_schedule_id).merge(member_id: current_user.member.id)
  end
end
