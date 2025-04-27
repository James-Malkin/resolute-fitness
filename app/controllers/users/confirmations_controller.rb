# frozen_string_literal: true

module Users
  class ConfirmationsController < Devise::ConfirmationsController
    def show
      super do |resource|
        Member.create(user: resource) if resource.member.nil?

        StripeManager::Customer.create(resource.member)
      end
    end
  end
end
