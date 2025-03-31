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
end
