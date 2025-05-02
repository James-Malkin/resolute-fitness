# frozen_string_literal: true

class Member < ApplicationRecord
  belongs_to :user

  has_many :bookings, dependent: :destroy
  has_many :class_schedules, through: :bookings

  enum :plan, { guest: 0, bronze: 1, silver: 2, gold: 3 }, default: :guest

  delegate :email, to: :user

  def update_subscription!(subscription)
    Rails.logger.debug "Updating subscription with ID: #{subscription.id}"
    update!(
      plan: subscription.plan.id,
      stripe_subscription_id: subscription.id,
      subscription_period_end: Time.at(subscription.items.data[0].current_period_end),
      default_payment_method_id: subscription.default_payment_method
    )
  end

  def plan_pill
    {
      guest: 'border-neutral-600 text-neutral-600',
      bronze: 'border-bronze text-bronze',
      silver: 'border-gray-400 text-gray-400',
      gold: 'border-yellow-500 text-yellow-500'
    }[plan.to_sym]
  end
end
