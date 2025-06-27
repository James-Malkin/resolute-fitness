# frozen_string_literal: true

class BookingEvaluator
  def self.payment_required?(user)
    return false if !user || user.employee

    user.member.guest?
  end

  def self.session_available?(class_schedule_id, current_user)
    return { is_available: false, reason: :unauthenticated } unless current_user

    return { is_available: false, reason: :unauthorized } unless Ability.new(current_user).can?(:create, Booking)

    return { is_available: false, reason: :unavailable } unless session_has_capacity?(class_schedule_id)

    { is_available: true, reason: nil }
  end

  def self.session_has_capacity?(class_schedule_id)
    return false unless class_schedule_id

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
