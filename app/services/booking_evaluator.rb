# frozen_string_literal: true

class BookingEvaluator
  def self.payment_required?(user)
    return false unless user

    user.member.guest?
  end

  def self.session_available?(class_schedule_id)
    class_schedule = ClassSchedule.find_by(id: class_schedule_id)

    class_schedule.bookings.count < class_schedule.capacity
  end

  def self.process_booking(booking_params, user)
    booking = Booking.new(booking_params)

    return [:error, nil] unless booking.save

    if payment_required?(user)
      [:payment_required, booking]
    else
      booking.update!(payment_status: :succeeded)
      [:payment_success, booking]
    end
  end
end
