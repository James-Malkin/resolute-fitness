# frozen_string_literal: true

class MembersController < ApplicationController
  before_action :authenticate_user!, only: %i[update subscribe]
  before_action :find_member, only: %i[update]

  def update
    if @member.update(member_params)
      redirect_to profile_show_path(@member.username), notice: 'Privacy preferences successfully updated'
    else
      @profile_presenter = UserProfilePresenter.new(@member.user, 'edit_profile')
      render profile_edit_path
    end
  end

  def subscribe
    StripeManager::Subscription.create(subscribe_params)
  end

  private

  def find_member
    @member = Member.find(params[:id])
  end

  def member_params
    params.require(:member).permit(:public_profile)
  end

  def subscribe_params
    params.permit(:id, :price_id, :payment_method_id)
  end
end
