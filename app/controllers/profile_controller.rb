# frozen_string_literal: true

class ProfileController < ApplicationController
  before_action :authenticate_user!, only: %i[index edit]

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
    @user.build_address unless @user.address
    @profile_presenter = UserProfilePresenter.new(@user, params[:page_context])
    @payment_methods = Stripe::PaymentMethod.list(
      customer: @user.member.stripe_customer_id,
      type: 'card'
    )
  end
end
