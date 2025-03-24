# frozen_string_literal: true

require 'rails_helper'

describe 'Profiles' do
  let(:user) { create(:user) }

  before do
    login_as user, scope: :user
  end

  it 'shows the profile page' do
    visit profile_path
    expect(page).to have_content(user.username)
  end
end
