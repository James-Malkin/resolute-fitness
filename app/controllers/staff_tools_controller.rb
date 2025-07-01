# frozen_string_literal: true

class StaffToolsController < ApplicationController
  before_action :authorize_user!

  def index
    @exercise_classes = ExerciseClass.page params[:class_page]
    @class_schedules = ClassSchedule.page params[:schedule_page]
  end

  private

  def authorize_user!
    authorize! :access, :staff_tools
  end
end
