require 'rails_helper'

describe 'Classes' do
  describe 'GET /classes' do
    let!(:classes) { create_list(:class, 3) }

    before do
      get classes_path
    end

    it 'returns a list of classes' do
      classes.each do |class_instance|
        expect(response.body).to include(class_instance.name)
      end
    end

    it 'returns a 200 status code' do
      expect(response.status).to eq(200)
    end
  end
end