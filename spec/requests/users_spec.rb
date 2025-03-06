require 'rails_helper'

describe 'Users' do
  
  describe 'GET /:username' do
    let(:user) { create(:user) }

    before do
      sign_in user
      visit user_path(user)
    end

    it "shows the user's profile information" do
      expect(page).to have_content(user.username)
      expect(page).to have_content(user.email)
    end
  end
end