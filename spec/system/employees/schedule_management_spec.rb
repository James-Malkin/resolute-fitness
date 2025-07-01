# frozen_string_literal: true

require 'rails_helper'

describe 'Schedule Management' do
  let!(:employee) { create(:employee) }
  let!(:exercise_class) { create(:exercise_class) }

  before { sign_in employee.user, scope: :user }

  describe 'creating a new class schedule', :js do
    before do
      visit staff_tools_path
      click_on 'Schedule Class'
    end

    it 'allows employees to create a new class schedule' do
      within '#modal_content' do
        select exercise_class.name, from: 'Class'
        select employee.username, from: 'Trainer'

        date_time = Time.current + 1.week
        select_datetime(date_time, from: 'Date and Time')

        fill_in 'Duration', with: '60'
        fill_in 'Capacity', with: '30'
        click_on 'Save'
      end

      expect(page).to have_content('Class schedule created successfully.')
      expect(ClassSchedule.last.exercise_class).to eq(exercise_class)
    end
  end
end
