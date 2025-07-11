# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # allow_browser versions: :modern

  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, alert: exception.message
  end

  private

  def update_turbo_frame(target_frame, partial:, locals:)
    render turbo_stream: turbo_stream.update(target_frame, partial:, locals:)
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit :sign_up, keys: %i[username email password password_confirmation]
    devise_parameter_sanitizer.permit :sign_in, keys: %i[login password remember_me]
    devise_parameter_sanitizer.permit :account_update, keys: %i[username email password password_confirmation current_password avatar]
  end
end
