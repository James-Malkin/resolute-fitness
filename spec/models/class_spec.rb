# frozen_string_literal: true

require 'rails_helper'

describe Class do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
    it { should validate_length_of(:description).is_at_most(280) }
    it { should validate_attachment_presence(:image) }
    it { should validate_attachment_content_type(:image).allowing('image/png', 'image/jpg', 'image/jpeg') }
    it { should validate_attachment_size(:image).less_than(5.megabytes) }
  end
end