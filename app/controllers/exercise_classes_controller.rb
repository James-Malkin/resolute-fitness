# frozen_string_literal: true

class ExerciseClassesController < ApplicationController
  def index
    @exercise_classes = ExerciseClass.all
  end

  def new
    @exercise_class = ExerciseClass.new
  end

  def create
    @exercise_class = ExerciseClass.new(exercise_class_params)
    if @exercise_class.save
      redirect_to exercise_classes_path, notice: 'Class created successfully.'
    else
      render :new
    end
  end

  private

  def exercise_class_params
    params.require(:exercise_class).permit(:name, :description, :image)
  end
end
