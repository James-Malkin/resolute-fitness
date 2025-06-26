# frozen_string_literal: true

FactoryBot.define do
  factory :class_schedule do
    association :trainer, factory: :employee
    association :exercise_class
    date_time { Faker::Time.forward(days: 14, period: :morning) }
    duration { rand(30..120) }
    capacity { rand(5..20) }
    price { rand(5..10) }
  end
end
