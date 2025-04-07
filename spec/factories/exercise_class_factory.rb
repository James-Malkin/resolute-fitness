# frozen_string_literal: true

FactoryBot.define do
  factory :exercise_class do
    name { Faker::Educator.course_name }
    description { Faker::Lorem.sentence(word_count: 10) }
    image { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'files', 'test_image.jpg'), 'image/png') }
  end
end
