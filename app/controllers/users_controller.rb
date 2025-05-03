# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :find_user

  def update
    if @user.update(user_params)
      redirect_to profile_show_path(@user.username), notice: 'User was successfully updated.'
    else
      @profile_presenter = UserProfilePresenter.new(@user, 'edit_email')
      render profile_edit_path
    end
  end

  def update_email
    if @user.update(email_params)
      flash[:notice] = 'Email was successfully updated.'
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.refresh(request_id: nil) }
        format.html { redirect_to profile_show_path(@user.username) }
      end
    else
      @profile_presenter = UserProfilePresenter.new(@user, 'edit_email')
      render profile_edit_path
    end
  end

  def update_username
    @user.update(params.require(:user).permit(:username))
    flash[:notice] = 'Username was successfully updated.'
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.refresh(request_id: nil) }
      format.html { redirect_to profile_edit_path }
    end
  end

  def cancel_change_email
    @user.cancel_change_email!
    redirect_back fallback_location: profile_show_path(@user.username), notice: 'Email change was successfully canceled.'
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
