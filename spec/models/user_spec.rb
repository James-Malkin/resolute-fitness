# frozen_string_literal: true

require 'rails_helper'

describe User do
  describe 'validations' do
    before { create(:user) }

    it { is_expected.to validate_presence_of(:username) }
    it { is_expected.to validate_length_of(:username).is_at_least(3).is_at_most(20) }
    it { is_expected.to validate_uniqueness_of(:username).case_insensitive }
    it { is_expected.to allow_value('valid-username').for(:username) }
    it { is_expected.not_to allow_value('invalid username!').for(:username) }
  end

  describe '.find_for_database_authentication' do
    subject(:user_found) { described_class.find_for_database_authentication(login: find_params) }

    let!(:user) { create(:user, email: 'test@example.com', username: 'test-user') }

    context 'when searching by email' do
      let(:find_params) { 'test@example.com' }

      it 'finds the user' do
        expect(user_found).to eq(user)
      end
    end

    context 'when searching by username' do
      let(:find_params) { 'test-user' }

      it 'finds the user' do
        expect(user_found).to eq(user)
      end
    end

    context 'when the search is invalid' do
      let(:find_params) { 'invalid@example.com' }

      it 'do not find the user' do
        expect(user_found).to be_nil
      end
    end
  end

  describe '#cancel_change_email!' do
    subject(:cancel_change_email) { user.cancel_change_email! }

    let(:user) { create(:user, :unconfirmed_change) }

    it 'clears the unconfirmed email' do
      expect { cancel_change_email }.to change(user, :unconfirmed_email).to(nil)
    end

    it 'clears the confirmation token' do
      expect { cancel_change_email }.to change(user, :confirmation_token).to(nil)
    end
  end

  describe '#full_name' do
    let(:user) { create(:user, first_name: 'John', last_name: 'Doe') }

    it 'returns the full name' do
      expect(user.full_name).to eq('John Doe')
    end
  end
end
