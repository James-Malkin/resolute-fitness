# frozen_string_literal: true

require 'rails_helper'

describe 'Bookings' do
  let(:member) { create(:member) }
  let(:exercise_class) { create(:exercise_class) }
  let(:class_schedule) { create(:class_schedule, exercise_class:) }

  before do
    sign_in member.user, scope: :user
  end

  describe 'GET /bookings/new' do
    context 'when the request is made with Turbo Frame' do
      before do
        get new_booking_path(class_schedule_id: class_schedule.id), headers: { 'Turbo-Frame' => 'booking_form' }
      end

      include_examples 'successful response'

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

  describe 'GET /bookings/:id/pay' do
    before do
      get pay_booking_path(booking.id)
    end

    let(:booking) { create(:booking, member:, class_schedule:) }

    it 'returns a 200 status code' do
      expect(response.status).to eq(200)
    end

    it 'renders the payment page' do
      expect(response.body).to include('Pay')
    end
  end

  describe 'POST /bookings' do
    subject(:post_booking) { post bookings_path, params: { booking: booking_params } }

    let!(:booking_params) { build(:booking, class_schedule:).attributes }

    context 'when the booking is created successfully' do
      it 'creates a new booking' do
        expect { post_booking }.to change(Booking, :count).by(1)
      end

      context 'when no payment is required' do
        let(:member) { create(:member, :with_plan) }

        it 'redirects to the bookings page' do
          post_booking
          expect(response).to redirect_to(profile_show_path(member.user.username))
        end

        it 'sets a flash message' do
          post_booking
          expect(flash[:notice]).to eq('Booking created successfully.')
        end
      end

      context 'when payment is required' do
        it 'redirects to the payment page' do
          post_booking
          expect(response).to redirect_to(pay_booking_path(Booking.last))
        end
      end
    end

    context 'when the booking creation fails' do
      let(:invalid_booking) { build(:booking, class_schedule: class_schedule) }

      before do
        allow(BookingEvaluator).to receive(:process_booking).and_return([:error, invalid_booking])
      end

      it 'does not create a new booking' do
        expect { post_booking }.not_to change(Booking, :count)
      end

      it 'renders the new booking page' do
        post_booking
        expect(response).to redirect_to(new_booking_path(class_schedule_id: class_schedule.id))
      end
    end
  end
end
