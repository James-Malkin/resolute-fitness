# frozen_string_literal: true

class ClassSchedulesController < ApplicationController
  def index
    @schedule_presenter = ClassSchedulePresenter.new(ClassSchedule.all)
  end
end
