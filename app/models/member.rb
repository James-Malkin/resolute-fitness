# frozen_string_literal: true

class Member < ApplicationRecord
  belongs_to :user

  has_many :bookings, dependent: :destroy
  has_many :class_schedules, through: :bookings
end
