# frozen_string_literal: true

FactoryBot.define do
  factory :member do
    stripe_customer_id { Faker::Internet.uuid }

    association :user

    trait :with_plan do
      plan { Member.plans.keys.reject { |plan| plan == 'guest' }.sample }
    end
  end
end
