# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { 'password' }
    username { Faker::Internet.username(specifier: 3..20, separators: %w[-]).gsub(/[^a-zA-Z0-9\-]/, '') }
    confirmed_at { Time.current }
    confirmation_sent_at { Time.current }
    confirmation_token { Devise.token_generator.generate(User, :confirmation_token).first }

    trait :unconfirmed_change do
      unconfirmed_email { Faker::Internet.email }
    end
  end
end
