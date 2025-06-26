# frozen_string_literal: true

require 'rails_helper'

describe 'Bookings' do
  describe 'creating a booking', :js do
    let!(:class_schedule) { create(:class_schedule) }

    context 'when the user is logged in' do
      before do
        sign_in user, scope: :user
        visit class_schedules_path
        click_on class_schedule.exercise_class.name
      end

      context 'when the user is a member with a plan' do
        let(:user) { create(:member, :with_plan).user }
        it 'displays a message' do
          expect(page).to have_content('You have successfully booked this class.')
          expect(page).to have_content('Sorry, you cannot book this class.')
        end
      end

      context 'when the user is a member with no plan' do
        let(:user) { create(:member).user }

        it 'displays a message' do
          expect(page).to have_content('Sorry, you cannot book this class.')
        end
      end

      context 'when the user is an employee' do
        let(:user) { create(:employee).user }

        it 'displays a message' do
          expect(page).to have_content('Sorry, you cannot book this class.')
        end
      end
    end

    context 'when the user is not logged in' do
      before do
        visit class_schedules_path
        click_on class_schedule.exercise_class.name
      end

      it 'displays a message' do
        expect(page).to have_content('Sorry, you cannot book this class.')
      end
    end
  end
end
