# frozen_string_literal: true

require 'rails_helper'

describe 'Class Management' do
  let(:employee) { create(:employee) }

  before { sign_in employee.user, scope: :user }

  describe 'creating an exercise class', :js do
    before do
      visit staff_tools_path
      click_on 'Create Class'
    end

    it 'allows employees to create a new exercise class' do
      within '#modal_content' do
        fill_in 'Class Name', with: 'Test Class'
        fill_in 'Description', with: 'This is a Test Description that will satisfy validation.'
        attach_file 'Image', Rails.root.join('spec', 'fixtures', 'files', 'test_image.jpg')
        click_on 'Save'
      end

      expect(page).to have_content('Class created successfully.')
      expect(ExerciseClass.last.name).to eq('Test Class')
    end

    it 'shows an error when required fields are missing' do
      within '#modal_content' do
        click_on 'Save'
      end

      expect(page).to have_content("Name can't be blank")
      expect(page).to have_content('Description is too short')
      expect(page).to have_content("Image can't be blank")
    end
  end

  it 'prevents the duplication of class names' do
    create(:exercise_class, name: 'Existing Class')

    within '#modal_content' do
      fill_in 'Class Name', with: 'Existing Class'
      fill_in 'Description', with: 'This is a Test Description that will satisfy validation.'
      attach_file 'Image', Rails.root.join('spec', 'fixtures', 'files', 'test_image.jpg')
      click_on 'Save'
    end

    expect(page).to have_content('Name has already been taken')
  end
end
