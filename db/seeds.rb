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

password = Rails.application.credentials[:seed_password]
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
  'Strength Foundations' => {
    description: 'This class teaches the fundamentals of weightlifting with a focus on proper form, ideal for beginners building a solid strength base.',
    image_path: 'strength_foundations.jpg'
  },
  'Cardio Blast' => {
    description: 'A high-energy workout incorporating diverse movements to elevate your heart rate and maximize calorie expenditure.',
    image_path: 'cardio_blast.jpg'
  },
  'HIIT Circuit' => {
    description: 'Experience the effectiveness of high-intensity interval training, alternating short bursts of intense activity with brief recovery periods.',
    image_path: 'hiit_circuit.jpg'
  },
  'Yoga Flow' => {
    description: 'Move through a fluid sequence of yoga poses to enhance flexibility, improve balance, and cultivate mental focus.',
    image_path: 'yoga_flow.jpg'
  },
  'Pilates Core' => {
    description: 'Strengthen your deep core muscles through controlled movements, leading to better posture and increased body stability.',
    image_path: 'pilates_core.jpg'
  },
  'Spin Power' => {
    description: 'A challenging indoor cycling class designed to improve cardiovascular fitness and build strength in your legs and glutes.',
    image_path: 'spin_power.jpg'
  },
  'Body Combat' => {
    description: 'This dynamic, martial arts-inspired class combines punches, kicks, and other movements for a full-body workout that improves agility and coordination.',
    image_path: 'body_combat.jpg'
  },
  'Barre Sculpt' => {
    description: 'A low-impact yet effective class using ballet-inspired exercises to tone muscles, improve posture, and increase flexibility.',
    image_path: 'barre_sculpt.jpg'
  },
  'Functional Fitness' => {
    description: 'Train your body for everyday tasks with exercises that mimic real-life movements, enhancing overall strength and mobility.',
    image_path: 'functional_fitness.jpg'
  },
  'Stretch & Recover' => {
    description: 'Dedicate time to improving your range of motion and accelerating muscle recovery through various stretching techniques and mobility work.',
    image_path: 'stretch_recover.jpg'
  }
}

exercise_classes.each do |key, data|
  ExerciseClass.create!(
    name: key,
    description: data[:description],
    image: File.open(Rails.root.join('db', 'seeds', 'images', 'exercise_classes', data[:image_path]))
  )
end

puts "\n== Creating class schedules for the next 6 months =="

# Get all exercise classes to rotate through
all_classes = ExerciseClass.all.to_a
class_count = all_classes.length

# Get a trainer to assign to classes
trainer = Employee.first
if trainer.nil?
  puts 'Error: No trainers found. Make sure you create employees first.'
  exit
end

# Calculate date range (today to 6 months from now)
start_date = Date.today
end_date = start_date + 6.months

# Track how many schedules created
created_count = 0

# For each day in the next 6 months
(start_date..end_date).each do |date|
  # Set class capacity based on day of week (higher capacity on weekends)
  capacity = date.on_weekend? ? 25 : 20

  # Morning class at 10:00 AM
  morning_class = all_classes[date.yday % class_count] # Rotate through classes
  morning_datetime = DateTime.new(date.year, date.month, date.day, 10, 0) # 10:00 AM

  morning_schedule = ClassSchedule.find_or_initialize_by(
    exercise_class: morning_class,
    date_time: morning_datetime
  )

  if morning_schedule.new_record?
    morning_schedule.capacity = capacity
    morning_schedule.duration = 60 # 60 minutes
    morning_schedule.trainer = trainer
    morning_schedule.price = 15.00
    morning_schedule.save!
    created_count += 1
  end

  # Afternoon class at 2:00 PM
  afternoon_class = all_classes[(date.yday + 5) % class_count] # Different class than morning
  afternoon_datetime = DateTime.new(date.year, date.month, date.day, 14, 0) # 2:00 PM

  afternoon_schedule = ClassSchedule.find_or_initialize_by(
    exercise_class: afternoon_class,
    date_time: afternoon_datetime
  )

  next unless afternoon_schedule.new_record?

  afternoon_schedule.capacity = capacity
  afternoon_schedule.duration = 60 # 60 minutes
  afternoon_schedule.trainer = trainer
  afternoon_schedule.price = 15.00
  afternoon_schedule.save!
  created_count += 1
end

puts "Created #{created_count} class schedules from #{start_date} to #{end_date}"
