# frozen_string_literal: true

class Booking < ApplicationRecord
  belongs_to :member
  belongs_to :class_schedule

  delegate :date_time, :duration, to: :class_schedule
  delegate :capacity, to: :class_schedule, prefix: true

  enum :payment_status, { pending: 0, succeeded: 1, failed: 2, cancelled: 3 }, default: :pending, validate: true

  after_create :schedule_prune_job

  private

  def schedule_prune_job
    PruneStaleBookingJob.set(wait: 15.minutes).perform_later(self)
  end
end
