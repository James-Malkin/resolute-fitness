# frozen_string_literal: true

require 'rails_helper'

describe JoinPlanPresenter do
  subject(:presenter) { described_class.new(member.user) }
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
        expect(presenter.member_payment_methods).to contain_exactly(
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
        .and_return([plan])
    end

    let(:plan) { build_plan }

    it 'returns a list of formatted plans' do
      expect(presenter.formatted_plans).to contain_exactly(
        have_attributes(
          id: 'price_123',
          display_colour: '#000000',
          description: 'Test Plan Description',
          price: "£10.00",
          features: have_attributes(
            time_restriction: "off_peak",
            peak_bookings: {type: :icon, value: "infinity", label: "Unlimited"},
            book_in_advance: "7 days"
          )
        )
      )
    end

    context 'when the plan has no peak bookings' do
      let(:plan) { build_plan(peak_bookings: 0) }

      it 'returns no peak bookings content' do
        expect(presenter.formatted_plans).to contain_exactly(
          have_attributes(
            features: have_attributes(
              peak_bookings: {type: :icon, value: "minus", label: "None"}
            )
          )
        )
      end
    end

    context 'when the plan has set peak bookings' do
      let(:plan) { build_plan(peak_bookings: 5) }

      it 'returns the correct peak bookings content' do
        expect(presenter.formatted_plans).to contain_exactly(
          have_attributes(
            features: have_attributes(
              peak_bookings: {type: :text, value: "5 bookings"}
            )
          )
        )
      end
    end
  end
end
