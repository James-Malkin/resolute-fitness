# frozen_string_literal: true

require 'rails_helper'

describe 'Exercise Classes' do
  describe 'GET /classes' do
    let!(:exercise_classes) { create_list(:exercise_class, 3) }

    before do
      get exercise_classes_path
    end

    it 'returns a list of classes' do
      exercise_classes.each do |exercise_class|
        expect(response.body).to include(exercise_class.name)
      end
    end

    it 'returns a 200 status code' do
      expect(response.status).to eq(200)
    end
  end
end
