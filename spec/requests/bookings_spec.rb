# frozen_string_literal: true

require 'rails_helper'

describe 'Bookings' do
  describe 'GET /bookings' do
    let!(:class_schedule) { create_list(:class_schedule, 3) }

    before do
      get class_schedules_path
    end

    it 'returns a 200 status code' do
      expect(response.status).to eq(200)
    end

    it 'renders the bookings page' do
      expect(response.body).to include('Book a class')
    end
  end
end
