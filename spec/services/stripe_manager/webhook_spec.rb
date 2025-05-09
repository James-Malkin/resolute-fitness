# frozen_string_literal: true

require 'rails_helper'

describe StripeManager::Webhook do
  describe '.build_event' do
    subject(:build_event) { described_class.build_event(request) }

    let(:request) { instance_double('Request', body: body, headers: headers) }
    let(:body) { StringIO.new('{"id": "evt_123"}') }
    let(:headers) { { 'HTTP_STRIPE_SIGNATURE' => 'signature' } }

    let(:event) { instance_double('Stripe::Event', type: 'payment_intent.succeeded') }

    context 'when the event is valid' do
      let(:event) { instance_double('Stripe::Event', type: 'payment_intent.succeeded') }

      before do
        allow(Stripe::Webhook).to receive(:construct_event).and_return(event)
      end

      it 'returns the event' do
        expect(build_event).to eq(event)
      end
    end

    context 'when the event is invalid' do
      let(:verification_error) { Stripe::SignatureVerificationError.new('Invalid signature', 'signature') }

      before do
        allow(Stripe::Webhook).to receive(:construct_event).and_raise(verification_error)
      end

      it 'raises a Stripe::SignatureVerificationError' do
        expect { build_event }.to raise_error(Stripe::SignatureVerificationError)
      end
    end
  end

  describe '.route_event' do
    subject(:route_event) { described_class.route_event(event) }

    let(:event) { instance_double(Stripe::Event, type: event_type, data: data) }
    let(:data) { instance_double('Stripe::EventData', object: object) }
    let(:object) { instance_double(Stripe::PaymentIntent, id: payment_intent_id) }
    let(:payment_intent_id) { 'pi_123' }

    before do
      allow(Booking).to receive(:find_by).and_return(booking)
      allow(booking).to receive(:update!)
    end

    context 'when the event type is payment_intent.succeeded' do
      let(:event_type) { 'payment_intent.succeeded' }
      let(:booking) { instance_double('Booking') }

      it 'updates the booking with succeeded status' do
        route_event

        expect(Booking).to have_received(:find_by).with(payment_intent_id: payment_intent_id)
        expect(booking).to have_received(:update!).with(payment_status: :succeeded)
      end
    end

    context 'when the event type is payment_intent.payment_failed' do
      let(:event_type) { 'payment_intent.payment_failed' }
      let(:booking) { instance_double('Booking') }

      it 'updates the booking with failed status' do
        route_event

        expect(Booking).to have_received(:find_by).with(payment_intent_id: payment_intent_id)
        expect(booking).to have_received(:update!).with(payment_status: :failed)
      end
    end
  end
end
