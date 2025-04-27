# frozen_string_literal: true

class Member < ApplicationRecord
  belongs_to :user

  has_many :bookings, dependent: :destroy
  has_many :class_schedules, through: :bookings

  enum :plan, { guest: 0, bronze: 1, silver: 2, gold: 3 }, default: :guest

  delegate :email, to: :user

  def update_subscription!(subscription)
    update!(
      stripe_subscription_id: subscription.id,
      subscription_period_start: Time.at(subscription.current_period_start),
      default_payment_method_id: subscription.default_payment_method
    )
  end
end
