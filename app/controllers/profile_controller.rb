# frozen_string_literal: true

class ProfileController < ApplicationController
  before_action :authenticate_user!, only: %i[index edit]

  rescue_from CanCan::AccessDenied do
    redirect_to root_path, alert: 'This profile is private'
  end

  def show
    @user = User.by_username(params[:username])

    authorize! :view, :profile, @user

    @profile_presenter = UserProfilePresenter.new(@user)
  end

  def edit
    @user = current_user
    @user.build_address unless @user.address
    @profile_presenter = UserProfilePresenter.new(@user, params[:page_context])
  end
end
