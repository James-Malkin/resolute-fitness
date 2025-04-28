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

  describe 'User confirmation' do
    let(:user) { create(:user, confirmation_token: 'token123') }

    before do
      allow(Stripe::Customer).to receive(:create).and_return(instance_double(Stripe::Customer, id: 'cus_123'))
      get user_confirmation_path(confirmation_token: user.confirmation_token)
    end

    it 'creates a member for the user' do
      expect(Member.last.user).to eq(user)
    end

    it 'creates a Stripe customer for the member' do
      expect(Stripe::Customer).to have_received(:create).with(
        email: user.email,
        metadata: { member_id: Member.last.id }
      )
    end
  end

  describe 'user abilities' do
    let(:user) { create(:user) }

    before do
      sign_in user, scope: :user
      allow_any_instance_of(Ability).to receive(:can?).and_return(false)
    end

    it 'denies access to unauthorized actions' do
      get staff_tools_path
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq('You are not authorized to access this page.')
    end
  end
end
