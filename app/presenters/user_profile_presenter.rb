# frozen_string_literal: true

class UserProfilePresenter
  def initialize(user, page_context = '')
    @user = user
    @page_context = page_context
  end

  def profile_type
    if @user.employee.present?
      'Employee'
    elsif @user.member.present?
      'Member'
    else
      'Guest'
    end
  end

  def email_pending?
    @user.unconfirmed_email.present?
  end

  def edit_email?
    @page_context == 'edit_email'
  end

  def edit_username?
    @page_context == 'edit_username'
  end

  def total_user_bookings
    Booking.where(member_id: @user.member.id).count
  end

  def user_booking_streak
    Booking.where(member_id: @user.member.id)
      .where('created_at >= ?', 7.days.ago)
      .count
  end

  def user_favourite_class
    return nil if @user.member.nil? || @user.member.bookings.empty?

    favorite = @user.member.bookings
    .joins(class_schedule: :exercise_class)
    .select('exercise_classes.name')
    .group('exercise_classes.name')
    .order('COUNT(exercise_classes.id) DESC')
    .first
    
    favorite&.name
  end

  def recent_user_bookings
    Booking.where(member_id: @user.member.id)
      .order(created_at: :desc)
      .limit(8)
  end
end
