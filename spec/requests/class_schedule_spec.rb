# frozen_string_literal: true

require 'rails_helper'

describe 'Staff Tools' do
  describe 'GET /staff/schedule/new' do
    before do
      get new_class_schedule_path
    end

    it 'returns a successful response' do
      expect(response).to have_http_status(:ok)
    end

    it 'renders the new booking form' do
      expect(response.body).to include('Schedule a Class')
    end
  end

  describe 'POST /staff/schedule' do
    subject(:post_class_schedule) { post class_schedules_path, params: { class_schedule: class_schedule_params } }

    let(:trainer) { create(:employee) }
    let(:exercise_class) { create(:exercise_class) }
    let!(:class_schedule_params) { build(:class_schedule, trainer:, exercise_class:).attributes }

    context 'when the class schedule is created successfully' do
      it 'creates a new class schedule' do
        expect { post_class_schedule }.to change(ClassSchedule, :count).by(1)
      end

      it 'redirects to the class schedule page' do
        post_class_schedule
        expect(response).to redirect_to(class_schedules_path)
      end

      it 'sets a flash message' do
        post_class_schedule
        expect(flash[:notice]).to eq('Class schedule created successfully.')
      end
    end

    context 'when the class schedule creation fails' do
      before do
        allow_any_instance_of(ClassSchedule).to receive(:save).and_return(false)
      end

      it 'does not create a new class schedule' do
        expect { post_class_schedule }.not_to change(ClassSchedule, :count)
      end

      it 'renders the new class schedule form again' do
        post_class_schedule
        expect(response.body).to include('Schedule a Class')
      end
    end
  end
end
