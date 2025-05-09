# frozen_string_literal: true

require 'rails_helper'

describe PruneStaleBookingJob do
  describe '#perform' do
    context 'when the booking is not paid' do
      let(:booking) { create(:booking, payment_status: :pending) }

      it 'updates the booking to cancelled' do
        expect { described_class.perform_now(booking) }
          .to change { booking.reload.payment_status }
          .from('pending')
          .to('cancelled')
      end
    end

    context 'when the booking is paid' do
      let(:booking) { create(:booking, payment_status: :succeeded) }

      it 'does not update the booking' do
        expect { described_class.perform_now(booking) }
          .not_to(change { booking.reload.payment_status })
      end
    end
  end
end
