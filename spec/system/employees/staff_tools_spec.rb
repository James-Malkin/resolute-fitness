# frozen_string_literal: true

require 'rails_helper'

describe 'Staff Tools' do
  let(:employee) { create(:employee) }

  let!(:exercise_class) { create(:exercise_class) }
  let!(:class_schedule) { create(:class_schedule, exercise_class:) }

  before do
    sign_in employee.user, scope: :user
    visit staff_tools_path
  end

  it 'allows employees to view exercise classes' do
    within '#class_table' do
      expect(page).to have_content(exercise_class.name)
    end
  end

  it 'allows employees to view class schedules' do
    within '#class_schedule_table' do
      expect(page).to have_content(class_schedule.date_time.strftime('%Y-%m-%d %H:%M'))
    end
  end
end
