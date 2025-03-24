# frozen_string_literal: true

class UserProfilePresenter
  def initialize(user)
    @user = user
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
end
