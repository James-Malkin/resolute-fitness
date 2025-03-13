# frozen_string_literal: true

require 'rails_helper'

describe 'Authentication' do
  describe 'user registration' do
    subject(:register_user) { post user_registration_path, params: registration_params }

    let(:registration_params) do
      {
        user: {
          username: 'test-user',
          email: 'test@example.com',
          password: 'password123',
          password_confirmation: 'password123'
        }
      }
    end

    it 'creates a new user with username' do
      expect { register_user }.to change(User, :count).by(1)
      expect(User.last.username).to eq('test-user')
    end

    it 'redirects to the root path after successful registration' do
      register_user
      expect(response).to redirect_to(root_path)
    end
  end

  describe 'user authentication' do
    subject(:login_user) { post user_session_path, params: login_params }

    let!(:user) { create(:user, username: 'test-user', email: 'test@example.com', password: 'password123') }

    context 'with valid credentials' do
      context 'when using username' do
        let(:login_params) do
          {
            user: {
              login: 'test-user',
              password: 'password123'
            }
          }
        end

        it 'successfully authenticates the user' do
          login_user
          expect(controller.current_user).to eq(user)
          expect(response).to redirect_to(root_path)
        end
      end

      context 'when using email' do
        let(:login_params) do
          {
            user: {
              login: 'test@example.com',
              password: 'password123'
            }
          }
        end

        it 'successfully authenticates the user' do
          login_user
          expect(controller.current_user).to eq(user)
          expect(response).to redirect_to(root_path)
        end
      end
    end

    context 'with invalid credentials' do
      let(:login_params) do
        {
          user: {
            login: 'test-user',
            password: 'wrong-password'
          }
        }
      end

      it 'fails to authenticate' do
        login_user
        expect(controller.current_user).to be_nil
        expect(response).not_to redirect_to(root_path)
      end
    end
  end
end
