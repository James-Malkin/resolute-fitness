# frozen_string_literal: true

require 'rails_helper'

describe PaymentMethodsPresenter do
  subject(:for_user) { described_class.for_user(member.user) }
  let(:member) { create(:member) }

  describe '#for_user' do
    context 'when the member has payment methods' do
      before do
        allow(Stripe::PaymentMethod).to receive(:list)
          .with(customer: member.stripe_customer_id, type: 'card')
          .and_return([build_payment_method])
      end

      it 'returns a list of formatted payment methods' do
        expect(for_user).to contain_exactly(
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
end
