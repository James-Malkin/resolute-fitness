# frozen_string_literal: true

require 'rails_helper'

describe 'Profile' do
  let(:user) { create(:user) }

  before do
    login_as user, scope: :user
  end

  describe 'GET /profile/edit' do
    it 'returns the edit profile page' do
      get profile_edit_path
      expect(response.body).to include(user.username)
    end
  end

  describe 'GET /profile/:username' do
    let!(:user_two) { create(:user) }

    context 'when the user is a member' do
      let!(:member) { create(:member, user: user_two) }

      context 'when the user has a public profile' do
        before do
          member.update(public_profile: true)
        end

        it 'shows the user profile information' do
          get profile_show_path(user_two.username)
          expect(response.body).to include(user_two.username)
        end
      end

      context 'when the user has a private profile' do
        before do
          member.update(public_profile: false)
        end

        it 'redirects to root' do
          get profile_show_path(user_two.username)
          expect(response).to redirect_to(root_path)
          follow_redirect!
          expect(response.body).to include('This profile is private')
        end
      end
    end
  end
end
