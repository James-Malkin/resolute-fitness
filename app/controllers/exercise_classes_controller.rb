# frozen_string_literal: true

class ExerciseClassesController < ApplicationController
  load_and_authorize_resource

  def index
    @featured_class = ExerciseClass.order('RANDOM()').first
    @exercise_classes = ExerciseClass.all
  end

  def new
    redirect_to root_path and return if request.headers['Turbo-Frame'].blank?

    render partial: 'new', locals: { exercise_class: ExerciseClass.new }
  end

  def edit
    redirect_to root_path and return if request.headers['Turbo-Frame'].blank?

    render partial: 'edit', locals: { exercise_class: @exercise_class }
  end

  def update
    if @exercise_class.update(exercise_class_params)
      redirect_to exercise_classes_path, notice: 'Class updated successfully.'
    else
      replace_turbo_frame('modal_content', partial: 'edit', locals: { exercise_class: @exercise_class })
    end
  end

  def create
    exercise_class = ExerciseClass.new(exercise_class_params)
    if exercise_class.save
      redirect_to exercise_classes_path, notice: 'Class created successfully.'
    else
      replace_turbo_frame('modal_content', partial: 'new', locals: { exercise_class: })
    end
  end

  private

  def exercise_class_params
    params.require(:exercise_class).permit(:name, :description, :image)
  end
end
