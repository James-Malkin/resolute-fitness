# frozen_string_literal: true

class ClassSchedulesController < ApplicationController
  load_and_authorize_resource

  def index
    @schedule_presenter = ClassSchedulePresenter.new(ClassSchedule.all)
  end

  def new
    redirect_to root_path and return if request.headers['Turbo-Frame'].blank?

    class_schedule = ClassSchedule.new

    render partial: 'new', locals: { class_schedule: }
  end

  def create
    class_schedule = ClassSchedule.new(class_schedule_params)
    if class_schedule.save
      redirect_to class_schedules_path, notice: 'Class schedule created successfully.'
    else
      update_turbo_frame(:modal_content, partial: 'new', locals: { class_schedule: })
    end
  end

  private

  def class_schedule_params
    params.require(:class_schedule).permit(:exercise_class_id, :date_time, :duration, :capacity, :trainer_id)
  end
end
