# frozen_string_literal: true

class PlansController < ApplicationController
  before_action :authenticate_user!, only: [:join]

  def index; end

  def join
    StripeManager::Customer.create(current_user.member)
  end
end
