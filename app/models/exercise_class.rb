# frozen_string_literal: true

class ExerciseClass < ApplicationRecord
  has_many :class_schedules, dependent: :destroy

  has_one_attached :image

  validates :name, presence: true, uniqueness: true
  validates :description, length: { minimum: 25, maximum: 280 }
  validates :image, attached: true,
                    content_type: { in: %w[image/png image/jpeg] },
                    size: { less_than: 5.megabytes }
end
