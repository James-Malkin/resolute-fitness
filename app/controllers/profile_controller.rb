# frozen_string_literal: true

class ProfileController < ApplicationController
  def index
    @user = current_user
    @profile_presenter = UserProfilePresenter.new(@user)
  end

  def show
    @user = User.find_by!(username: params[:username])
    @profile_presenter = UserProfilePresenter.new(@user)
  end

  def edit
    @user = current_user
  end
end
