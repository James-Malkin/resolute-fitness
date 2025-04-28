require 'rails_helper'

RSpec.describe StripeManager::Subscription do
  describe '.create' do
    subject(:create_subscription) { described_class.create(subscription_params) }

    let(:member) { create(:member) }
    let(:subscription_params) do
      {
        id: member.id,
        price_id: 'price_123',
        payment_method_id: 'pm_123'
      }
    end

    let(:subscription) do
      instance_double(
        Stripe::Subscription,
        id: 'sub_123',
        default_payment_method: 'pm_123',
        items: double(data: [instance_double('Stripe::SubscriptionItem', current_period_end: 1.day.from_now.to_i)])
      )
    end

    before do
      allow(Member).to receive(:find).with(subscription_params[:id]).and_return(member)
      allow(member).to receive(:update_subscription!)
      allow(Stripe::Subscription).to receive(:create).and_return(subscription)
    end

    context 'when creating a subscription' do
      before { create_subscription }

      it 'creates a subscription with the correct parameters' do
        expect(Stripe::Subscription).to have_received(:create).with(
          customer: member.stripe_customer_id,
          items: [{ price: subscription_params[:price_id] }],
          default_payment_method: subscription_params[:payment_method_id]
        )
      end

      it 'updates the member with the subscription details' do
        expect(member).to have_received(:update_subscription!).with(subscription)
      end
    end

    context 'when a Stripe::CardError occurs' do
      before do
        allow(Stripe::Subscription).to receive(:create).and_raise(Stripe::CardError.new('Card error', nil))
      end

      it 'rescues from the error and logs it' do
        expect(Rails.logger).to receive(:error).with('Stripe CardError: Card error')
        create_subscription
      end
    end
  end
end