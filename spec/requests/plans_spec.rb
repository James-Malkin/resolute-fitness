# frozen_string_literal: true

require 'rails_helper'

describe 'Plans' do
  describe 'GET /join' do
    let(:member) { create(:member) }
    let(:payment_method) do
      Stripe::PaymentMethod.construct_from(
        id: 'pm_123',
        card: {
          brand: 'Visa',
          last4: '1234',
          exp_month: 12,
          exp_year: 2025
        }
      )
    end
    let(:plan) do
      Stripe::Plan.construct_from(
        id: 'price_123',
        nickname: 'Basic Plan',
        amount: 1000,
        currency: 'gbp',
        interval: 'month',
        interval_count: 1,
        metadata: {
          plan_type: 'basic'
        }
      )
    end

    before do
      sign_in member.user, scope: :user

      allow(Stripe::PaymentMethod).to receive(:list).and_return(
        Stripe::ListObject.construct_from(data: [payment_method])
      )

      allow(Stripe::Plans).to receive(:all).and_return(
        Stripe::ListObject.construct_from(data: [plan])
      )

      get join_plans_path
    end

    it 'returns the join page' do
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Join')
    end

    it 'displays the payment methods' do
      expect(response.body).to include(payment_method.card.brand)
    end

    it 'displays the plans' do
      expect(response.body).to include(plan.nickname)
      expect(response.body).to include('£10.00')
    end
  end
end
