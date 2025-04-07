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

  describe 'GET /classes/new' do
    before do
      get new_exercise_class_path
    end

    it 'returns a 200 status code' do
      expect(response.status).to eq(200)
    end

    it 'renders the new class form' do
      expect(response.body).to include('New Class')
    end
  end

  describe 'POST /classes' do
    subject(:post_classes) { post exercise_classes_path, params: { exercise_class: exercise_class_params } }

    let!(:exercise_class_params) do
      {
        name: 'Yoga',
        description: 'A relaxing yoga class.',
        image: fixture_file_upload(Rails.root.join('spec', 'fixtures', 'files', 'test_image.jpg'), 'image/jpeg')
      }
    end

    context 'when the class is created successfully' do
      it 'creates a new class' do
        expect { post_classes }.to change(ExerciseClass, :count).by(1)
      end
    end

    context 'when the class creation fails' do
      before do
        allow_any_instance_of(ExerciseClass).to receive(:save).and_return(false)
      end

      it 'does not create a new class' do
        expect { post_classes }.not_to change(ExerciseClass, :count)
      end
    end
  end
end
