# frozen_string_literal: true

require 'rails_helper'

describe 'Profiles' do
  let(:user) { create(:user) }

  before do
    sign_in user, scope: :user
  end

  it 'shows the profile page' do
    visit profile_show_path(user.username)
    expect(page).to have_content(user.username)
  end

  context 'when the user is a member' do
    let(:member) { create(:member, public_profile: true) }
    let!(:booking) { create(:booking, member_id: member.id) }

    before { visit profile_show_path(member.user.username) }

    it 'displays user metrics' do
      expect(page).to have_content('Total Workouts')
      expect(page).to have_content('Week Streak')
      expect(page).to have_content('Favourite Class')
    end

    it 'displays recent activity' do
      expect(page).to have_content('Recent Activity')
      expect(page).to have_content(booking.class_schedule.exercise_class_name)
    end

    context 'when a member has a private profile', :js do
      let(:member) { create(:member, public_profile: false) }

      it 'shows the private profile message' do
        expect(page).to have_content('This profile is private')
      end
    end
  end

  context 'when the user is an employee' do
    let(:employee) { create(:employee) }

    before { visit profile_show_path(employee.user.username) }

    it 'shows the employee profile page' do
      expect(page).to have_content(employee.user.username)
      expect(page).to have_content('EMPLOYEE')
    end
  end
end
