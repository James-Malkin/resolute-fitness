# frozen_string_literal: true

class ClassSchedulesController < ApplicationController
  def index
    @class_schedules = ClassSchedule.all
  end
end