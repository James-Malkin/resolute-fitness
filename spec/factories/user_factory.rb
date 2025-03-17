# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { 'password' }
    username { Faker::Internet.username }
    confirmed_at { Time.current }
    confirmation_sent_at { Time.current }
    confirmation_token { Devise.token_generator.generate(User, :confirmation_token).first }
  end
end
