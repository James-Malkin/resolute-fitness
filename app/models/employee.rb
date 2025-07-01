# frozen_string_literal: true

class Employee < ApplicationRecord
  belongs_to :user
  has_many :class_schedules

  delegate :username, :full_name, to: :user
end
