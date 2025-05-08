# frozen_string_literal: true

require 'rails_helper'

describe 'Payment Methods' do
  describe 'POST /subscribe' do
    subject(:post_payment_methods) { post payment_methods_path, params: params }

    let(:params) { { payment_method_id: 'pm_123' } }

    let(:member) { create(:member) }

    before do
      sign_in member.user, scope: :user
      allow(Stripe::PaymentMethod).to receive(:attach)
      post_payment_methods
    end

    it 'redirects to the profile edit page' do
      expect(response).to redirect_to(profile_edit_path)
    end
  end
end
