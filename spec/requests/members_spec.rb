# frozen_string_literal: true

require 'rails_helper'

describe 'Members' do
  describe 'POST /subscribe' do
    subject(:post_subscribe) { post subscribe_member_path(member.id), params: params }

    let(:params) do
      {
        price_id: 'price_123',
        payment_method_id: 'pm_123'
      }
    end

    let(:member) { create(:member) }

    before do
      allow(StripeManager::Subscription).to receive(:create)
      post_subscribe
    end

    it 'creates a subscription' do
      expect(StripeManager::Subscription).to have_received(:create).with(
        ActionController::Parameters.new(
          id: member.id.to_s,
          price_id: 'price_123',
          payment_method_id: 'pm_123'
        ).permit!
      )
    end
  end
end
