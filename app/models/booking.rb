# frozen_string_literal: true

class Booking < ApplicationRecord
  belongs_to :member
  belongs_to :class_schedule

  delegate :date_time, :duration, to: :class_schedule
  delegate :capacity, to: :class_schedule, prefix: true
end
