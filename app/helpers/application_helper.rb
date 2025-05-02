# frozen_string_literal: true

module ApplicationHelper
  def error_message_for(object, attribute)
    return unless object.errors[attribute].any?

    attribute_name = object.class.human_attribute_name(attribute)

    tag.p(class: 'error-message') do
      "#{attribute_name} #{object.errors[attribute].join(', ')}"
    end
  end

  def toast_icon(type)
    case type
    when 'success'
      'circle-check'
    when 'notice'
      'info'
    when 'error'
      'circle-alert'
    when 'alert'
      'triangle-alert'
    end
  end
end
