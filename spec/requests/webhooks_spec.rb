# frozen_string_literal: true

require 'rails_helper'

describe 'Webhooks' do
  describe 'POST /stripe/webhooks' do
    subject(:post_webhook) { post webhooks_path, params: payload, headers: headers }

    let(:payload) { { event: 'payment_intent.succeeded' }.to_json }
    let(:headers) { { 'HTTP_STRIPE_SIGNATURE' => 'test_signature' } }

    let(:event) { instance_double('Stripe::Event', type: 'payment_intent.succeeded') }

    context 'when the event is valid' do
      before do
        allow(Stripe::Webhook).to receive(:construct_event).and_return(event)
        allow(StripeManager::Webhook).to receive(:route_event)
        post_webhook
      end

      it 'returns a 200 status' do
        post_webhook
        expect(response).to have_http_status(:ok)
      end

      it 'routes the event' do
        expect(StripeManager::Webhook).to have_received(:route_event).with(event)
      end
    end

    context 'when the event is invalid' do
      let(:verification_error) { Stripe::SignatureVerificationError.new('Invalid signature', 'signature') }

      before do
        allow(StripeManager::Webhook).to receive(:route_event)
        allow(Stripe::Webhook).to receive(:construct_event).and_raise(verification_error)
        post_webhook
      end

      it 'returns a 400 status' do
        expect(response).to have_http_status(:bad_request)
      end

      it 'does not route the event' do
        expect(StripeManager::Webhook).not_to have_received(:route_event)
      end
    end
  end
end
