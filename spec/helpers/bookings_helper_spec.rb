# frozen_string_literal: true

require 'rails_helper'

describe BookingsHelper do
  describe '#availability_content' do
    it 'returns unauthenticated message' do
      expect(helper.availability_content(:unauthenticated)).to include('You must be logged in to book a class.')
    end

    it 'returns unauthorized message' do
      expect(helper.availability_content(:unauthorized)).to include('You do not have permission to book classes.')
    end

    it 'returns unavailable message' do
      expect(helper.availability_content(:unavailable)).to include('This session is no longer available for booking.')
    end
  end
end
