# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :find_user

  def update
    if @user.update(user_params)
      redirect_to profile_path, notice: 'User was successfully updated.'
    else
      render profile_edit_path
    end
  end

  def cancel_change_email
    @user.cancel_change_email!
    redirect_back fallback_location: profile_path, notice: 'Email change was successfully canceled.'
  end

  private

  def find_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :username, :password, :password_confirmation)
  end
end
