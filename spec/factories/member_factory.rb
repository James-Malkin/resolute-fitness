# frozen_string_literal: true

FactoryBot.define do
  factory :member do
    stripe_customer_id { 'cus_123' }

    association :user
  end
end
