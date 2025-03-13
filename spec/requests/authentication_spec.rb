# frozen_string_literal: true

require 'rails_helper'

describe 'Authentication' do
  describe 'POST /users/sign_up' do
    subject(:post_user_registration_path) { post user_registration_path params: }

    let(:params) do
      {
        user: {
          username: 'test-user',
          email: 'test@example.com',
          password: 'password123',
          password_confirmation: 'password123'
        }
      }
    end

    it 'permits username parameter during registration' do
      expect { post_user_registration_path }.to change(User, :count).by(1)
    end
  end

  describe 'POST /users/sign_in' do
    subject(:post_user_session_path) { post user_session_path params: }

    let!(:user) { create(:user, username: 'test-user', email: 'test@example.com', password: 'password123') }

    context 'when logging in with username' do
      let(:params) do
        {
          user: {
            login: 'test-user',
            password: 'password123'
          }
        }
      end

      before do
        post_user_session_path
      end

      it 'logs the user in' do
        expect(response).to redirect_to(root_path)
      end
    end

    context 'when logging in with email' do
      let(:params) do
        {
          user: {
            login: 'test@example.com',
            password: 'password123'
          }
        }
      end

      before do
        post_user_session_path
      end

      it 'logs the user in' do
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
