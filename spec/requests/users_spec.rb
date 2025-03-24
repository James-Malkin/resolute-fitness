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
end
