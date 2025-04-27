# frozen_string_literal: true

class Users::ConfirmationsController < Devise::ConfirmationsController
  def show
    super do |resource|
      Member.create(user: resource) if resource.member.nil?

      StripeManager::Customer.create(resource.member)
    end
  end
end
