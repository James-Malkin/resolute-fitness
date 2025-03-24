# frozen_string_literal: true

FactoryBot.define do
  factory :member do
    association :user
  end
end
