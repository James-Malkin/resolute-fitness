# frozen_string_literal: true

FactoryBot.define do
  factory :booking do
    association :member
    association :class_schedule
  end
end
