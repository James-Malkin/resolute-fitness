# frozen_string_literal: true

class ClassSchedule < ApplicationRecord
  belongs_to :trainer, class_name: 'Employee'
  belongs_to :exercise_class

  delegate :name, to: :exercise_class, prefix: true
end
