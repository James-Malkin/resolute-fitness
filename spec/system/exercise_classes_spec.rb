require 'rails_helper'

describe 'Exercise Classes' do
  let!(:exercise_classes) { create_list(:exercise_class, 3) }

  before { visit exercise_classes_path }

  it 'displays a list of exercise classes' do
    exercise_classes.each do |exercise_class|
      expect(page).to have_content(exercise_class.name)
    end
  end
end
