# frozen_string_literal: true

class ExerciseClass < ApplicationRecord
  has_one_attached :image

  validates :name, presence: true, uniqueness: true
  validates :description, length: { maximum: 280 }, allow_blank: false
  validates :image, attached: true,
                    content_type: { in: %w[image/png image/jpeg] },
                    size: { less_than: 5.megabytes }
end
