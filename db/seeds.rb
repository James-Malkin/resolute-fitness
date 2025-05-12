# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

password = ENV.fetch('SEED_PASSWORD', nil)
password_confirmation = password

employee_user = User.create!(
  email: 'employee@resolutefitness.studio',
  username: 'james-malkin',
  password: password,
  password_confirmation: password_confirmation,
  confirmed_at: Time.current,
)
Employee.create!(user: employee_user)

users = [
  { email: 'guest@resolutefitness.studio', username: 'james-guest', plan: :guest },
  { email: 'bronze@resolutefitness.studio', username: 'james-bronze', plan: :bronze },
  { email: 'silver@resolutefitness.studio', username: 'james-silver', plan: :silver },
  { email: 'gold@resolutefitness.studio', username: 'james-gold', plan: :gold }
]

for user in users
  user_record = User.create!(
    email: user[:email],
    username: user[:username],
    password: password,
    password_confirmation: password_confirmation,
    confirmed_at: Time.current,
  )
  member = Member.create!(user: user_record, plan: user[:plan], public_profile: true)
  StripeManager::Customer.create(member)
end