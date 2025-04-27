# frozen_string_literal: true

require 'rails_helper'

describe Member do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:bookings) }
    it { is_expected.to have_many(:class_schedules).through(:bookings) }
  end

  describe '#update_subscription!' do
    subject(:update_subscription) { member.update_subscription!(subscription) }

    let(:member) { create(:member) }
    let(:current_period_end) { 1.day.from_now.to_i }
    let(:subscription_item) { instance_double('Stripe::SubscriptionItem', current_period_end: current_period_end) }
    let(:subscription) do
      instance_double(
        Stripe::Subscription,
        id: 'sub_123',
        default_payment_method: 'pm_123',
        items: double(
          data: [subscription_item]
        )
      )
    end

    it 'updates the member with the subscription details' do
      expect { update_subscription }
        .to change(member, :stripe_subscription_id).to('sub_123')
        .and change(member, :subscription_period_end).to(Time.at(current_period_end))
        .and change(member, :default_payment_method_id).to('pm_123')
    end
  end
end
