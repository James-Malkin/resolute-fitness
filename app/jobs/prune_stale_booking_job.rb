# frozen_string_literal: true

class PruneStaleBookingJob < ApplicationJob
  queue_as :default

  def perform(booking)
    return if booking.payment_status == :succeeded

    booking.update!(payment_status: :cancelled)
  end
end
