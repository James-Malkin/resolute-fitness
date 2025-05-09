require 'rails_helper'

describe BookingEvaluator do
  describe '.payment_required?' do
    let(:user) { create(:user, member:) }

    context 'when the member is a guest' do
      let(:member) { create(:member) }

      it 'returns true' do
        expect(described_class.payment_required?(user)).to be true
      end
    end

    context 'when the member is not a guest' do
      let(:member) { create(:member, :with_plan) }

      it 'returns false' do
        expect(described_class.payment_required?(user)).to be false
      end
    end
  end

  describe '.process_booking' do
    subject(:process_booking) { described_class.process_booking(booking_params, user) }

    let(:member) { create(:member) }
    let(:user) { create(:user, member:) }
    let(:booking_params) { { class_schedule_id: class_schedule.id, member_id: member.id } }
    let(:class_schedule) { create(:class_schedule) }

    context 'when payment is required' do
      it 'creates a new booking' do
        expect { process_booking }.to change(Booking, :count).by(1)
      end

      it 'returns :payment_required' do
        result = process_booking
        expect(result).to eq([:payment_required, Booking.last])
      end      
    end

    context 'when payment is not required' do
      let(:member) { create(:member, :with_plan) }

      before do
        allow(StripeManager::PaymentIntent).to receive(:create)
      end

      it 'creates a new booking' do
        expect { process_booking }.to change(Booking, :count).by(1)
      end

      it 'returns :payment_success' do
        result = process_booking
        expect(result).to eq([:payment_success, Booking.last])
      end

      it 'updates the booking with payment status' do
        process_booking
        expect(Booking.last.payment_status).to eq('succeeded')
      end
    end

    context 'when booking fails to save' do
      let(:booking_params) { { class_schedule_id: nil } }

      it 'does not create a new booking' do
        expect { process_booking }.not_to change(Booking, :count)
      end

      it 'returns :error' do
        result = process_booking
        expect(result).to eq([:error, nil])
      end
    end
  end
end
