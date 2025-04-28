# frozen_string_literal: true

require 'rails_helper'

describe JoinPlanPresenter do
  subject(:presenter) { described_class.new(member) }
  let(:member) { create(:member) }

  describe '#initialize' do
    it 'assigns the member' do
      expect(presenter.instance_variable_get(:@member)).to eq(member)
    end
  end

  describe '#member_has_a_plan?' do
    context 'when the member has a plan' do
      let(:member) { create(:member, :with_plan) }

      it 'returns true' do

        expect(presenter.member_has_a_plan?).to be true
      end
    end

    context 'when the member does not have a plan' do
      it 'returns false' do
        expect(presenter.member_has_a_plan?).to be false
      end
    end
  end

  describe '#member_payment_methods' do
    context 'when the member has payment methods' do
      before do
        allow(Stripe::PaymentMethod).to receive(:list)
          .with(customer: member.stripe_customer_id, type: 'card')
          .and_return([build_payment_method])
      end

      it 'returns a list of formatted payment methods' do
        expect(presenter.member_payment_methods).to include(
          have_attributes(
            id: 'pm_123',
            brand: 'Visa',
            last4: '1234',
            exp_month: 12,
            exp_year: 2050
          )
        )
      end
    end
  end

  describe '#formatted_plans' do
    before do
      allow(Stripe::Plans).to receive(:all)
        .and_return([build_plan])
    end

    it 'returns a list of formatted plans' do
      expect(presenter.formatted_plans).to include(
        have_attributes(
          id: 'price_123',
          nickname: 'Basic Plan',
          price: '£10.00'
        )
      )
    end
  end
end