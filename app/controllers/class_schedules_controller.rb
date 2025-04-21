# frozen_string_literal: true

class ClassSchedulesController < ApplicationController
  load_and_authorize_resource

  def index
    @schedule_presenter = ClassSchedulePresenter.new(ClassSchedule.all)
  end

  def new
    @class_schedule = ClassSchedule.new
  end

  def create
    @class_schedule = ClassSchedule.new(class_schedule_params)
    if @class_schedule.save
      redirect_to class_schedules_path, notice: 'Class schedule created successfully.'
    else
      render :new
    end
  end

  private

  def class_schedule_params
    params.require(:class_schedule).permit(:exercise_class_id, :date_time, :duration, :capacity, :trainer_id)
  end
end
