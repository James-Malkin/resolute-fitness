# frozen_string_literal: true

require 'rails_helper'

describe 'Bookings' do
  let(:stripe_helper) { StripeMock.create_test_helper }

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

        it 'displays the book button' do
          expect(page).to have_content('Book')
        end

        it 'allows the user to book a class' do
          expect do
            click_on 'Book'
          end.to change(Booking, :count).by(1)
          expect(page).to have_content('Booking created successfully.')
          expect(page).to have_current_path(profile_show_path(user.username))
        end
      end

      context 'when the user is a member with no plan' do
        let(:user) { create(:member).user }

        before do
          allow(Stripe::PaymentIntent).to receive(:create).and_return(build_payment_intent)
        end

        it 'renders the payment form' do
          expect(page).to have_css('#payment_form')
        end

        it 'creates a booking that requires payment' do
          expect do
            click_on 'Continue to Payment'
          end.to change(Booking, :count).by(1)
          expect(Booking.last.payment_status).to eq('pending')
          expect(page).to have_css("form[action='/bookings/1/pay']")
        end
      end

      context 'when the user is an employee' do
        let(:user) { create(:employee).user }

        it 'displays a message' do
          expect(page).to have_content('You do not have permission to book classes.')
        end
      end
    end

    context 'when the user is not logged in' do
      before do
        visit class_schedules_path
        click_on class_schedule.exercise_class.name
      end

      it 'displays a message' do
        expect(page).to have_content('You must be logged in to book a class.')
      end
    end
  end
end
