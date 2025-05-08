class BookingEvaluator
  def self.payment_required?(user)
    user.member.guest?
  end

  def self.process_booking(booking_params, user)
    booking = Booking.new(booking_params)

    return [:error, booking] unless booking.save
    
    if payment_required?(user)
      [:payment_required, booking]
    else
      booking.update!(payment_status: :succeeded)
      [:payment_success, booking]
    end
  end
end
