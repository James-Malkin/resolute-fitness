# frozen_string_literal: true

class Employee < ApplicationRecord
  belongs_to :user
  has_many :class_schedules

  delegate :username, to: :user
end
