# frozen_string_literal: true

require 'rails_helper'

describe BookingEvaluator do
  describe '.payment_required?' do
    subject(:payment_required) { described_class.payment_required?(user) }

    let(:user) { create(:user, member:) }

    context 'when the member is a guest' do
      let(:member) { create(:member) }

      it { is_expected.to be true }
    end

    context 'when the member is not a guest' do
      let(:member) { create(:member, :with_plan) }

      it { is_expected.to be false }
    end
  end

  describe '.session_available?' do
    subject(:session_available?) { described_class.session_available?(class_schedule.id, user) }

    let(:class_schedule) { create(:class_schedule) }

    context 'when the user is not authenticated' do
      let(:user) { nil }

      it 'returns false with reason :unauthenticated' do
        expect(session_available?).to eq({ is_available: false, reason: :unauthenticated })
      end
    end

    context 'when the user is authenticated but unauthorized' do
      let(:user) { create(:user) }

      before do
        allow(Ability).to receive(:new).with(user).and_return(Ability.new(user))
        allow_any_instance_of(Ability).to receive(:can?).with(:create, Booking).and_return(false)
      end

      it 'returns false with reason :unauthorized' do
        expect(session_available?).to eq({ is_available: false, reason: :unauthorized })
      end
    end

    context 'when the user is authenticated and authorized' do
      let(:user) { create(:user, member: create(:member)) }

      before do
        allow(Ability).to receive(:new).with(user).and_return(Ability.new(user))
        allow_any_instance_of(Ability).to receive(:can?).with(:create, Booking).and_return(true)
      end

      context 'when the class schedule has capacity' do
        it 'returns true with no reason' do
          expect(session_available?).to eq({ is_available: true, reason: nil })
        end
      end

      context 'when the class schedule is at full capacity' do
        before do
          create_list(:booking, class_schedule.capacity, class_schedule:)
        end

        it 'returns false with reason :unavailable' do
          expect(session_available?).to eq({ is_available: false, reason: :unavailable })
        end
      end
    end
  end

  describe '.session_has_capacity?' do
    subject(:session_has_capacity?) { described_class.session_has_capacity?(class_schedule.id) }

    let(:class_schedule) { create(:class_schedule) }

    context 'when the class schedule has capacity' do
      it 'returns true' do
        expect(session_has_capacity?).to be true
      end
    end

    context 'when the class schedule is at full capacity' do
      before do
        create_list(:booking, class_schedule.capacity, class_schedule:)
      end

      it 'returns false' do
        expect(session_has_capacity?).to be false
      end
    end

    context 'when class schedule ID is nil' do
      it 'returns false' do
        expect(described_class.session_has_capacity?(nil)).to be false
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
