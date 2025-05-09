# frozen_string_literal: true

require 'rails_helper'

describe 'Payments' do
  describe 'POST /stripe/payments' do
    subject(:create_payment) { post '/stripe/payments', params: { booking_id: booking.id } }

    before do
      allow(StripeManager::PaymentIntent).to receive(:create).and_return(payment_intent)
      sign_in member.user, scope: :user
      create_payment
    end

    let(:payment_intent) do
      instance_double(
        Stripe::PaymentIntent,
        id: 'pi_123',
        client_secret: 'secret_123'
      )
    end

    let(:booking) { create(:booking, member:) }
    let(:member) { create(:member) }

    it 'returns a JSON response with the payment intent details' do
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(JSON.parse(response.body)).to eq(
        'client_secret' => 'secret_123',
        'payment_intent_id' => 'pi_123'
      )
    end
  end
end
