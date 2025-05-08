# frozen_string_literal: true

require 'rails_helper'

describe 'Members' do
  let(:member) { create(:member) }

  before do
    sign_in member.user, scope: :user
  end

  describe 'POST /members/:id/subscribe' do
    subject(:post_subscribe) { post subscribe_member_path(member.id), params: params }

    let(:params) do
      {
        price_id: 'price_123',
        payment_method_id: 'pm_123'
      }
    end

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

  describe 'PATCH /members/:id' do
    subject(:patch_update) { patch member_path(member.id), params: { member: { public_profile: true } } }

    let(:member) { create(:member) }

    context 'the update is successful' do
      before do
        patch_update
      end

      it 'updates the member' do
        expect(member.reload.public_profile).to be true
      end

      it 'sets a flash notice' do
        follow_redirect!
        expect(response.body).to include('Privacy preferences successfully updated')
      end
    end

    context 'the update fails' do
      before do
        allow_any_instance_of(Member).to receive(:update).and_return(false)
        patch_update
      end

      it 'does not updates the member' do
        expect(member.reload.public_profile).to be false
      end

      it 're-renders the edit page' do
        expect(response.body).to include('Privacy Preferences')
      end
    end
  end
end
