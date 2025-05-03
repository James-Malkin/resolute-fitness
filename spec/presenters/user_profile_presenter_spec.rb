# frozen_string_literal: true

require 'rails_helper'

describe UserProfilePresenter do
  subject(:presenter) { described_class.new(user) }
  let(:user) { create(:user) }

  describe '#initialize' do
    it 'assigns the user' do
      expect(presenter.instance_variable_get(:@user)).to eq(user)
    end
  end

  describe '#profile_type' do
    context 'when the user is an employee' do
      let(:user) { create(:employee).user }

      it 'returns "Employee"' do
        expect(presenter.profile_type).to eq('Employee')
      end
    end

    context 'when the user is a member' do
      let(:user) { create(:member).user }

      it 'returns "Member"' do
        expect(presenter.profile_type).to eq('Member')
      end
    end

    context 'when the user is a guest' do
      it 'returns "Guest"' do
        expect(presenter.profile_type).to eq('Guest')
      end
    end
  end

  describe '#email_pending?' do
    context 'when the user has an unconfirmed email' do
      let(:user) { create(:user, :unconfirmed_change) }

      it 'returns true' do
        expect(presenter.email_pending?).to be true
      end
    end

    context 'when the user has a confirmed email' do
      it 'returns false' do
        expect(presenter.email_pending?).to be false
      end
    end
  end

  describe '#user_favourite_class' do
    let(:user) { create(:member).user }

    context 'when the user has a favourite class' do
      let(:exercise_class) { create(:exercise_class, name: 'Test') }
      let(:class_schedule) { create(:class_schedule, exercise_class: exercise_class) }

      before do
        create(:booking, member: user.member, class_schedule: class_schedule)
      end

      it 'returns the favourite class' do
        expect(presenter.user_favourite_class).to eq('Test')
      end
    end

    context 'when the user does not have a favourite class' do
      it 'returns nil' do
        expect(presenter.user_favourite_class).to be_nil
      end
    end
  end
end
