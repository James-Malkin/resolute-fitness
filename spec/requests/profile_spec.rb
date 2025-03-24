# frozen_string_literal: true

require 'rails_helper'

describe 'Profile' do
  let(:user) { create(:user) }

  before do
    login_as user, scope: :user
  end

  describe 'GET /profile' do
    it 'returns the user profile page' do
      get profile_path
      expect(response.body).to include(user.username)
    end
  end
  
    describe 'GET /profile/edit' do
      it 'returns the edit profile page' do
        get profile_edit_path
        expect(response.body).to include(user.username)
      end
    end

  describe 'GET /profile/:username' do
    let!(:user_two) { create(:user) }

    it 'shows the user profile information' do
      get profile_show_path(user_two.username)
      expect(response.body).to include(user_two.username)
    end
  end
end
