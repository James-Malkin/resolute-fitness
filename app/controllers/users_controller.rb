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

  def update_email
    if @user.update(email_params)
      redirect_to profile_path, notice: 'Email was successfully updated.'
    else
      render 'profile/edit'
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
    params.require(:user).permit(:username, :password, :password_confirmation, :avatar)
  end

  def email_params
    params.require(:user).permit(:email)
  end
end
