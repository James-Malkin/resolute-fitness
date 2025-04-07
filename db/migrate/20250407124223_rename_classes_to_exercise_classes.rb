class RenameClassesToExerciseClasses < ActiveRecord::Migration[8.0]
  def change
    rename_table :classes, :exercise_classes
  end
end
