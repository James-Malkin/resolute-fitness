# frozen_string_literal: true

require 'rails_helper'

describe StripeManager::PaymentIntent do
  describe '.create' do
    subject(:create_payment_intent) { described_class.create(member, booking) }

    let(:booking) { create(:booking, member:) }
    let(:member) { create(:member) }

    let(:payment_intent) do
      instance_double(
        Stripe::PaymentIntent,
        id: 'pi_123',
        client_secret: 'secret_123'
      )
    end

    before do
      allow(Stripe::PaymentIntent).to receive(:create).and_return(payment_intent)
    end

    it 'creates a payment intent with the correct parameters' do
      create_payment_intent

      expect(Stripe::PaymentIntent).to have_received(:create).with(
        amount: (booking.class_schedule.price * 100).to_i,
        currency: 'gbp',
        payment_method_types: ['card'],
        customer: member.stripe_customer_id,
        metadata: {
          member_id: member.id,
          booking_id: booking.id
        }
      )
    end

    it 'updates the booking with the payment intent ID' do
      create_payment_intent

      expect(booking.reload.payment_status).to eq('pending')
      expect(booking.payment_intent_id).to eq('pi_123')
    end
  end
end
