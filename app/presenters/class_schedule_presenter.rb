# frozen_string_literal: true

class ClassSchedulePresenter
  def initialize(class_schedules)
    @class_schedules = class_schedules
  end

  def next_two_weeks_by_date
    @class_schedules
      .where(date_time: Time.zone.now.beginning_of_day..2.weeks.from_now.end_of_day)
      .order(:date_time)
      .group_by { |cs| cs.date_time.to_date }
  end
end
