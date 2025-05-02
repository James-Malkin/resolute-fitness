# frozen_string_literal: true

require 'rails_helper'

describe ApplicationHelper do
  describe '#toast_icon' do
    it 'returns the correct icon for success' do
      expect(helper.toast_icon('success')).to eq('circle-check')
    end
    it 'returns the correct icon for notice' do
      expect(helper.toast_icon('notice')).to eq('info')
    end
    it 'returns the correct icon for error' do
      expect(helper.toast_icon('error')).to eq('circle-alert')
    end
    it 'returns the correct icon for alert' do
      expect(helper.toast_icon('alert')).to eq('triangle-alert')
    end
    it 'returns the default icon for unknown type' do
      expect(helper.toast_icon('unknown')).to eq('circle-help')
    end
  end
end
