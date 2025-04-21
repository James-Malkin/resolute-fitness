# frozen_string_literal: true

require 'rails_helper'

describe 'Bookings' do
  describe 'GET /bookings/new' do
    let(:exercise_class) { create(:exercise_class) }
    let!(:class_schedule) { create(:class_schedule, exercise_class:) }

    context 'when the request is made with Turbo Frame' do
      before do
        get new_booking_path(class_schedule_id: class_schedule.id), headers: { 'Turbo-Frame' => 'booking_form' }
      end

      it 'returns a 200 status code' do
        expect(response.status).to eq(200)
      end

      it 'renders the new booking page' do
        expect(response.body).to include(exercise_class.name)
      end
    end

    context 'when the request is made without Turbo Frame' do
      before do
        get new_booking_path(class_schedule_id: class_schedule.id)
      end

      it 'redirects to the root path' do
        expect(response).to redirect_to(root_path)
      end

      it 'does not render the new booking page' do
        expect(response.body).not_to include(exercise_class.name)
      end

      it 'returns a 302 status code' do
        expect(response.status).to eq(302)
      end
    end
  end

  describe 'POST /bookings' do
    subject(:post_booking) { post bookings_path, params: { booking: booking_params } }

    let(:member) { create(:member) }
    let(:class_schedule) { create(:class_schedule) }
    let!(:booking_params) { build(:booking, member:, class_schedule:).attributes }

    before do
      sign_in member.user, scope: :user
    end

    context 'when the booking is created successfully' do
      it 'creates a new booking' do
        expect { post_booking }.to change(Booking, :count).by(1)
      end

      it 'redirects to the bookings page' do
        post_booking
        expect(response).to redirect_to(bookings_path)
      end

      it 'sets a flash message' do
        post_booking
        expect(flash[:notice]).to eq('Booking created successfully.')
      end
    end

    context 'when the booking creation fails' do
      before do
        allow_any_instance_of(Booking).to receive(:save).and_return(false)
      end

      it 'does not create a new booking' do
        expect { post_booking }.not_to change(Booking, :count)
      end

      it 'renders the new booking page' do
        post_booking
        expect(response.body).to include(class_schedule.exercise_class_name)
      end

      it 'returns a 422 status code' do
        post_booking
        expect(response.status).to eq(422)
      end
    end
  end
end
