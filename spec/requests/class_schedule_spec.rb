# frozen_string_literal: true

require 'rails_helper'

describe 'Class Schedules' do
  let(:trainer) { create(:employee) }

  describe 'GET /class_schedules' do
    before do
      create_list(:class_schedule, 3)
      get class_schedules_path
    end

    include_examples 'successful response'

    it 'renders the bookings page' do
      expect(response.body).to include('Book a Class')
    end
  end

  describe 'GET /class_schedules/new' do
    before { sign_in trainer.user, scope: :user }

    context 'when the request is made from a Turbo Frame' do
      before { get new_class_schedule_path, headers: { 'Turbo-Frame' => 'booking_form' } }

      include_examples 'successful response'

      it 'renders the new booking form' do
        expect(response.body).to include('Schedule a Class')
      end
    end

    context 'when the request is made from outside a Turbo Frame' do
      before { get new_class_schedule_path }

      it 'redirects to the root path with appropriate status' do
        expect(response).to redirect_to(root_path)
        expect(response).to have_http_status(:found)
      end
    end
  end

  describe 'POST /class_schedules' do
    subject(:make_request) { post class_schedules_path, params: { class_schedule: class_schedule_params }, as: :turbo_stream }

    let(:exercise_class) { create(:exercise_class) }
    let(:class_schedule_params) { build(:class_schedule, trainer:, exercise_class:).attributes }

    before { sign_in trainer.user, scope: :user }

    context 'when the class schedule is created successfully' do
      it 'creates a new class schedule' do
        expect { make_request }.to change(ClassSchedule, :count).by(1)
      end

      it 'redirects to the class schedule page with success message' do
        make_request
        expect(response).to redirect_to(class_schedules_path)
        expect(flash[:notice]).to eq('Class schedule created successfully.')
      end
    end

    context 'when the class schedule creation fails' do
      before do
        allow_any_instance_of(ClassSchedule).to receive(:save).and_return(false)
        make_request
      end

      it 'does not create a new class schedule' do
        expect(ClassSchedule.count).to eq(0)
      end

      include_examples 'turbo stream response'

      it 'includes a turbo-stream to replace the modal content' do
        expect(response.body).to include('<turbo-stream action="replace"')
        expect(response.body).to include('target="modal_content"')
      end
    end
  end
end
