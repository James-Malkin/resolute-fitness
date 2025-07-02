# frozen_string_literal: true

require 'rails_helper'

describe 'Plans' do
  let(:plan1) { build_plan(id: 'one', amount: 1000) }
  let(:plan2) { build_plan(id: 'two', amount: 2000) }
  let(:plan3) { build_plan(id: 'three', amount: 3000) }
  let(:plans) { [plan1, plan2, plan3] }

  before do
    allow(Stripe::Plans).to receive(:all).and_return(plans)
    visit plans_path
  end

  it 'displays a list of plans' do
    expect(page).to have_content(plan1.id.upcase)
    expect(page).to have_content(plan1.metadata.description)
    expect(page).to have_content('£10.00')
  end

  context 'when a member is authenticated', :js do
    let(:member) { create(:member) }
    let(:subscription) { build_subscription }

    before do
      allow(Stripe::Subscription).to receive(:create).and_return(subscription)
      allow_any_instance_of(PaymentMethodsPresenter).to receive(:for_user).and_return(payment_methods)
      sign_in member.user, scope: :user
      visit plans_path
      choose 'price_id', option: plan1.id
    end

    context 'when the member has a payment method' do
      let(:payment_method) do
        PaymentMethodsPresenter::PaymentMethod.new(
          id: 'pm_test_123',
          brand: 'visa',
          last4: '4242',
          exp_month: 12,
          exp_year: 2025
        )
      end

      let(:payment_methods) { [payment_method] }

      it 'allows members to purchase a plan' do
        choose 'payment_method_id', option: payment_method.id
        click_button 'Join'

        expect(page).to have_content('Plan purchased successfully')
      end
    end

    context 'when the member does not have a payment method' do
      let(:payment_methods) { [] }

      it 'prompts the user to add a payment method' do
        expect(page).to have_content('No payment methods available.')
        expect(page).to have_button('Join', disabled: true)
      end
    end
  end
end
