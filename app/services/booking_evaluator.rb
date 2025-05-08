class BookingEvaluator
  def self.payment_required?(user)
    return true if user.member.guest?

    false
  end

  def self.process_booking(booking_params, user)
    booking = Booking.new(booking_params)
    
    if booking.save
      if payment_required?(user)
        return [:payment_required, booking]
      else
        booking.update!(payment_status: :succeeded)
        return [:payment_success, booking]
      end
    end
    
    [:error, booking]
  end
end
