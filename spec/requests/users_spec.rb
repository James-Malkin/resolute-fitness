# frozen_string_literal: true

require 'rails_helper'

describe 'Users' do
  describe 'PATCH /users/:id' do
    subject(:patch_user) { patch user_path(user), params: { user: { username: 'new_username' } } }

    let(:user) { create(:user) }

    context 'when the update is succeeds' do
      it 'updates the user' do
        patch_user
        user.reload
        expect(user.username).to eq('new_username')
      end
    end

    context 'when the update fails' do
      before do
        allow_any_instance_of(User).to receive(:update).and_return(false)
      end

      it 'does not update the user' do
        patch_user
        user.reload
        expect(user.username).not_to eq('new_username')
      end
    end
  end

  describe 'PATCH /users/:id/update_email' do
    subject(:update_email) { patch update_email_user_path(user), params: { user: { email: } } }

    let(:user) { create(:user) }
    let(:email) { 'test@example.com' }

    before do
      update_email
    end

    context 'when the update is succeeds' do
      it 'redirects to the profile page' do
        expect(response).to redirect_to(profile_path)
      end

      it 'updates user unconfirmed email' do
        user.reload
        expect(user.unconfirmed_email).to eq('test@example.com')
      end
    end

    context 'when the update fails' do
      let(:email) { 'invalid_email' }

      it 'rerenders the edit profile page' do
        expect(response.body).to include('Email is invalid')
      end

      it 'does not update the user email' do
        expect(user.unconfirmed_email).not_to eq('test@example.com')
      end
    end
  end

  describe 'DELETE /users/:id/cancel_change_email' do
    subject(:cancel_change_email) { delete cancel_change_email_user_path(user) }

    let(:user) { create(:user, :unconfirmed_change) }

    before do
      cancel_change_email
    end

    it 'returns a success message' do
      expect(response).to redirect_to(profile_path)
      expect(flash[:notice]).to eq('Email change was successfully canceled.')
    end
  end

  describe 'PATCH /users/:id/update_username' do
    subject(:update_username) { patch update_username_user_path(user), params: { user: { username: } } }

    let(:user) { create(:user) }
    let(:username) { 'new_username' }

    before do
      update_username
    end

    context 'when the update is succeeds' do
      it 'redirects to the profile page' do
        expect(response).to redirect_to(profile_edit_path)
      end

      it 'updates user username' do
        user.reload
        expect(user.username).to eq('new_username')
      end
    end
  end
end
