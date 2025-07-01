# frozen_string_literal: true

class ClassSchedule < ApplicationRecord
  belongs_to :trainer, class_name: 'Employee'
  belongs_to :exercise_class

  has_many :bookings, dependent: :destroy
  has_many :members, through: :bookings

  delegate :name, :description, to: :exercise_class, prefix: true
  delegate :full_name, to: :trainer, prefix: true
end
