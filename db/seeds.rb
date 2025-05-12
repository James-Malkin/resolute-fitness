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
  first_name: 'James',
  last_name: 'Malkin',
  avatar: File.open(Rails.root.join('db', 'seeds', 'images', 'profile_picture.jpg'))
)
Employee.create!(user: employee_user)

users = [
  { email: 'guest@resolutefitness.studio', username: 'james-guest', plan: :guest },
  { email: 'bronze@resolutefitness.studio', username: 'james-bronze', plan: :bronze },
  { email: 'silver@resolutefitness.studio', username: 'james-silver', plan: :silver },
  { email: 'gold@resolutefitness.studio', username: 'james-gold', plan: :gold }
]

users.each do |user|
  user_record = User.create!(
    email: user[:email],
    username: user[:username],
    password: password,
    password_confirmation: password_confirmation,
    confirmed_at: Time.current,
    avatar: File.open(Rails.root.join('db', 'seeds', 'images', 'profile_picture.jpg'))
  )
  member = Member.create!(user: user_record, plan: user[:plan], public_profile: true)
  StripeManager::Customer.create(member)
end

exercise_classes = {
  "Strength Foundations" => {
    description: "This class teaches the fundamentals of weightlifting with a focus on proper form, ideal for beginners building a solid strength base.",
    image_path: "strength_foundations.jpg"
  },
  "Cardio Blast" => {
    description: "A high-energy workout incorporating diverse movements to elevate your heart rate and maximize calorie expenditure.",
    image_path: "cardio_blast.jpg"
  },
  "HIIT Circuit" => {
    description: "Experience the effectiveness of high-intensity interval training, alternating short bursts of intense activity with brief recovery periods.",
    image_path: "hiit_circuit.jpg"
  },
  "Yoga Flow" => {
    description: "Move through a fluid sequence of yoga poses to enhance flexibility, improve balance, and cultivate mental focus.",
    image_path: "yoga_flow.jpg"
  },
  "Pilates Core" => {
    description: "Strengthen your deep core muscles through controlled movements, leading to better posture and increased body stability.",
    image_path: "pilates_core.jpg"
  },
  "Spin Power" => {
    description: "A challenging indoor cycling class designed to improve cardiovascular fitness and build strength in your legs and glutes.",
    image_path: "spin_power.jpg"
  },
  "Body Combat" => {
    description: "This dynamic, martial arts-inspired class combines punches, kicks, and other movements for a full-body workout that improves agility and coordination.",
    image_path: "body_combat.jpg"
  },
  "Barre Sculpt" => {
    description: "A low-impact yet effective class using ballet-inspired exercises to tone muscles, improve posture, and increase flexibility.",
    image_path: "barre_sculpt.jpg"
  },
  "Functional Fitness" => {
    description: "Train your body for everyday tasks with exercises that mimic real-life movements, enhancing overall strength and mobility.",
    image_path: "functional_fitness.jpg"
  },
  "Stretch & Recover" => {
    description: "Dedicate time to improving your range of motion and accelerating muscle recovery through various stretching techniques and mobility work.",
    image_path: "stretch_recover.jpg"
  }
}

exercise_classes.each do |key, data|
  ExerciseClass.create!(
    name: key,
    description: data[:description],
    image: File.open(Rails.root.join('db', 'seeds', 'images', 'exercise_classes', data[:image_path]))
  )
end
