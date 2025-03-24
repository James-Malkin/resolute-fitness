# frozen_string_literal: true

require 'rails_helper'

describe UserProfilePresenter do
  subject(:presenter) { described_class.new(user) }
  let(:user) { create(:user) }

  describe '#initialize' do
    it 'assigns the user' do
      expect(presenter.instance_variable_get(:@user)).to eq(user)
    end
  end

  describe '#profile_type' do
    context 'when the user is an employee' do
      let(:user) { create(:employee).user }

      it 'returns "Employee"' do
        expect(presenter.profile_type).to eq('Employee')
      end
    end

    context 'when the user is a member' do
      let(:user) { create(:member).user }

      it 'returns "Member"' do
        expect(presenter.profile_type).to eq('Member')
      end
    end

    context 'when the user is a guest' do
      it 'returns "Guest"' do
        expect(presenter.profile_type).to eq('Guest')
      end
    end
  end
end
