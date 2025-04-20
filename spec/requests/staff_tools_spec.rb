# frozen_string_literal: true

require 'rails_helper'

describe 'Staff Tools' do
  describe 'GET /staff' do
    subject(:get_staff_tools) { get staff_tools_path }

    let(:user) { create(:employee).user }

    before do
      sign_in user, scope: :user
      get_staff_tools
    end

    it 'returns a successful response' do
      expect(response).to have_http_status(:ok)
    end

    it 'displays the correct title' do
      expect(response.body).to include('Staff Tools')
    end
  end
end
