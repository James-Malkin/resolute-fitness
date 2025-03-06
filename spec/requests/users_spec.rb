require 'rails_helper'

describe 'Users' do
  describe 'GET /:username' do
    let(:user) { create(:user) }

    before do
      sign_in user, scope: user
      get user_path(user.username)
    end

    it "shows the user's profile information" do
      expect(response.body).to include(user.username)
      expect(response.body).to include(user.email)
    end
  end
end