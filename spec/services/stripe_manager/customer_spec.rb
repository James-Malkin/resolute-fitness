# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StripeManager::Customer do
  describe '.create' do
    context 'when the member does not have a stripe customer ID' do
      let(:member) { create(:member, stripe_customer_id: nil) }
      let(:stripe_customer) { instance_double('Stripe::Customer', id: 'cus_123') }

      before do
        allow(Stripe::Customer).to receive(:create).and_return(stripe_customer)
        allow(member).to receive(:update!)
      end

      it 'creates a new Stripe customer' do
        described_class.create(member)
        expect(Stripe::Customer).to have_received(:create).with(
          email: member.email,
          metadata: { member_id: member.id }
        )
      end

      it 'updates the member with the new stripe customer ID' do
        described_class.create(member)
        expect(member).to have_received(:update!).with(stripe_customer_id: 'cus_123')
      end
    end

    context 'when the member already has a stripe customer ID' do
      let(:member) { create(:member, stripe_customer_id: 'cus_123') }

      it 'does not create a new Stripe customer' do
        expect(Stripe::Customer).not_to receive(:create)
        described_class.create(member)
      end

      it 'does not update the member' do
        expect(member).not_to receive(:update!)
        described_class.create(member)
      end
    end
  end
end
