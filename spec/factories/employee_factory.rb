# frozen_string_literal: true

FactoryBot.define do
  factory :employee do
    association :user
  end
end
