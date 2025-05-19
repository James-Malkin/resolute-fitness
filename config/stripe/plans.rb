# frozen_string_literal: true

# This file contains descriptions of all your stripe plans

# Example
# Stripe::Plans::PRIMO #=> 'primo'

# Stripe.plan :primo do |plan|
#   # plan name as it will appear on credit card statements
#   plan.name = 'Acme as a service PRIMO'
#
#   # amount in cents. This is 6.99
#   plan.amount = 699
#
#   # currency to use for the plan (default 'usd')
#   plan.currency = 'usd'
#
#   # interval must be either 'day', 'week', 'month' or 'year'
#   plan.interval = 'month'
#
#   # only bill once every three months (default 1)
#   plan.interval_count = 3
#
#   # number of days before charging customer's card (default 0)
#   plan.trial_period_days = 30
# end

# Once you have your plans defined, you can run
#
#   rake stripe:prepare
#
# This will export any new plans to stripe.com so that you can
# begin using them in your API calls.

Stripe.plan :bronze do |plan|
  plan.name = 'Bronze'
  plan.amount = 1999
  plan.currency = 'gbp'
  plan.interval = 'month'
  plan.metadata = {
    description: 'Off-peak access only. Perfect for flexible schedules.',
    time_restriction: 'off_peak',
    peak_bookings: 0,
    book_in_advance: 7
  }
end

Stripe.plan :silver do |plan|
  plan.name = 'Silver'
  plan.amount = 2999
  plan.currency = 'gbp'
  plan.interval = 'month'
  plan.metadata = {
    description: 'Off-peak access + limited peak access. Ideal for regular users.',
    time_restriction: 'limited_peak',
    peak_bookings: 8,
    book_in_advance: 7
  }
end

Stripe.plan :gold do |plan|
  plan.name = 'Gold'
  plan.amount = 3999
  plan.currency = 'gbp'
  plan.interval = 'month'
  plan.metadata = {
    description: 'Unrestricted access. Perfect for fitness enthusiasts.',
    time_restriction: nil,
    peak_bookings: nil,
    book_in_advance: 14
  }
end
