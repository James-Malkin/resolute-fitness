# frozen_string_literal: true

ActionView::Base.field_error_proc = proc do |html_tag, _instance|
  if /<(input|select|textarea)/.match?(html_tag)
    doc = Nokogiri::HTML::DocumentFragment.parse(html_tag)
    field = doc.at_css('input, select, textarea')

    if field
      classes = field['class'] || ''
      field['class'] = "#{classes} invalid".strip unless classes.include?('invalid')
      html_tag = field.to_html.html_safe
    end
  end

  html_tag
end
