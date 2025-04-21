# frozen_string_literal: true

require 'rails_helper'

describe 'Exercise Classes' do
  let(:employee) { create(:employee) }

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
      sign_in employee.user, scope: :user
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

    before do
      sign_in employee.user, scope: :user
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

  describe 'GET /classes/:id/edit' do
    let(:exercise_class) { create(:exercise_class) }

    before do
      sign_in employee.user, scope: :user
      get edit_exercise_class_path(exercise_class)
    end

    it 'returns a 200 status code' do
      expect(response.status).to eq(200)
    end

    it 'renders the edit class form' do
      expect(response.body).to include('Edit Class')
    end
  end

  describe 'PATCH /classes/:id' do
    let(:exercise_class) { create(:exercise_class) }
    let(:exercise_class_params) do
      {
        name: 'Updated Class Name',
        description: 'Updated description.',
        image: fixture_file_upload(Rails.root.join('spec', 'fixtures', 'files', 'test_image.jpg'), 'image/jpeg')
      }
    end

    subject(:patch_class) { patch exercise_class_path(exercise_class), params: { exercise_class: exercise_class_params } }

    before do
      sign_in employee.user, scope: :user
    end

    context 'when the class is updated successfully' do
      it 'updates the class' do
        patch_class
        expect(exercise_class.reload.name).to eq('Updated Class Name')
      end
    end

    context 'when the class update fails' do
      before do
        allow_any_instance_of(ExerciseClass).to receive(:update).and_return(false)
      end

      it 'does not update the class' do
        patch_class
        expect(exercise_class.reload.name).not_to eq('Updated Class Name')
      end
    end
  end
end
