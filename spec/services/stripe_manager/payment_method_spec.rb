require 'rails_helper'

RSpec.describe StripeManager::PaymentMethod do
  describe '.attach' do
    subject(:attach_payment_method) { described_class.attach(member, payment_method_id) }

    let(:member) { create(:member) }
    let(:payment_method_id) { 'pm_123' }

    before do
      allow(Stripe::PaymentMethod).to receive(:attach)
    end

    context 'when attaching a payment method' do
      before { attach_payment_method }

      it 'attaches the payment method with the correct parameters' do
        expect(Stripe::PaymentMethod).to have_received(:attach).with(
          payment_method_id,
          {
            customer: member.stripe_customer_id
          }
        )
      end
    end
  end
end