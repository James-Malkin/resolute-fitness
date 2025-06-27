# frozen_string_literal: true

module BookingsHelper
  def availability_content(reason)
    case reason
    when :unauthenticated
      availability_message { requires_login_content }
    when :unauthorized
      availability_message { 'You do not have permission to book classes.' }
    when :unavailable
      availability_message { 'This session is no longer available for booking.' }
    end
  end

  private

  def availability_message(&)
    content_tag(:p, class: 'mb-3 text-center', &)
  end

  def requires_login_content
    concat 'You must be logged in to book a class.'
    concat link_to('Log in here.', new_user_session_path, class: 'ml-1 text-primary underline')
  end
end
