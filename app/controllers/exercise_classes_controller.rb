# frozen_string_literal: true

class ExerciseClassesController < ApplicationController
  load_and_authorize_resource

  def index
    @featured_class = ExerciseClass.order('RANDOM()').first
    @exercise_classes = ExerciseClass.all
  end

  def new
    @exercise_class = ExerciseClass.new
  end

  def edit; end

  def update
    if @exercise_class.update(exercise_class_params)
      redirect_to exercise_classes_path, notice: 'Class updated successfully.'
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace('exercise_class_form', partial: 'exercise_classes/form', locals: { exercise_class: @exercise_class }) }
        format.html { render :edit }
      end
    end
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
