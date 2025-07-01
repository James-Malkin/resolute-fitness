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

  describe 'GET /class_schedules/new' do
    before { sign_in employee.user, scope: :user }

    context 'when the request is made from a Turbo Frame' do
      before { get new_exercise_class_path, headers: { 'Turbo-Frame' => 'test_frame' } }

      include_examples 'successful response'

      it 'renders the new booking form' do
        expect(response.body).to include('Create a Class')
      end
    end

    context 'when the request is made from outside a Turbo Frame' do
      before { get new_exercise_class_path }

      it 'redirects to the root path with appropriate status' do
        expect(response).to redirect_to(root_path)
        expect(response).to have_http_status(:found)
      end
    end
  end

  describe 'POST /classes' do
    subject(:make_request) { post exercise_classes_path, params: { exercise_class: exercise_class_params }, as: :turbo_stream }

    let(:exercise_class_params) do
      attributes_for(:exercise_class).merge(
        image: fixture_file_upload(Rails.root.join('spec', 'fixtures', 'files', 'test_image.jpg'), 'image/jpeg')
      )
    end

    before { sign_in employee.user, scope: :user }

    context 'when the class is created successfully' do
      it 'creates a new class' do
        expect { make_request }.to change(ExerciseClass, :count).by(1)
      end
    end

    context 'when the class creation fails' do
      before do
        allow_any_instance_of(ExerciseClass).to receive(:save).and_return(false)
        make_request
      end

      it 'does not create a new class' do
        expect(ExerciseClass.count).to eq(0)
      end

      include_examples 'turbo stream response'

      it 'includes a turbo-stream to update the modal content' do
        expect(response.body).to include('<turbo-stream action="update"')
        expect(response.body).to include('target="modal_content"')
      end
    end
  end

  describe 'GET /classes/:id/edit' do
    let(:exercise_class) { create(:exercise_class) }

    before { sign_in employee.user, scope: :user }

    context 'when the request is made from a Turbo Frame' do
      before { get edit_exercise_class_path(exercise_class), headers: { 'Turbo-Frame' => 'test_frame' } }

      include_examples 'successful response'

      it 'renders the edit class form' do
        expect(response.body).to include('Edit Class')
      end
    end

    context 'when the request is made from outside a Turbo Frame' do
      before { get edit_exercise_class_path(exercise_class) }

      it 'redirects to the root path with appropriate status' do
        expect(response).to redirect_to(root_path)
        expect(response).to have_http_status(:found)
      end
    end
  end

  describe 'PATCH /classes/:id' do
    let(:exercise_class) { create(:exercise_class) }
    let(:exercise_class_params) do
      {
        name: 'Updated Class Name',
        description: 'This is an updated description that will satisfy validation.',
        image: fixture_file_upload(Rails.root.join('spec', 'fixtures', 'files', 'test_image.jpg'), 'image/jpeg')
      }
    end

    subject(:patch_class) { patch exercise_class_path(exercise_class), params: { exercise_class: exercise_class_params } }

    before do
      sign_in employee.user, scope: :user
    end

    context 'when the class is updated successfully' do
      before { patch_class }

      shared_examples 'successful response'

      it 'redirects to the exercise classes page' do
        expect(response).to redirect_to(exercise_classes_path)
      end

      it 'updates the class' do
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
