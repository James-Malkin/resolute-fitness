# frozen_string_literal: true

require 'rails_helper'

describe User do
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
end
