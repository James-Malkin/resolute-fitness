# frozen_string_literal: true

require 'rails_helper'

describe ExerciseClass do
  describe 'validations' do
    let!(:exercise_class) { create(:exercise_class) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
    it { is_expected.to validate_length_of(:description).is_at_most(280) }
    it { is_expected.to have_one_attached(:image) }
  end
end
