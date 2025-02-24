require 'rails_helper'

describe 'Home' do
  it 'shows the home page' do
    visit root_path
    expect(page).to have_content('Home')
  end
end
