# frozen_string_literal: true

class ExerciseClassesController < ApplicationController
  def index
    @exercise_classes = ExerciseClass.all
  end
end
