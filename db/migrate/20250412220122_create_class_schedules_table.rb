class CreateClassSchedulesTable < ActiveRecord::Migration[8.0]
  def change
    create_table :class_schedules do |t|
      t.datetime :date_time, null: false
      t.integer :duration, null: false
      t.integer :capacity, null: false
      t.references :exercise_class, null: false, foreign_key: true
      t.references :trainer, null: false, foreign_key: { to_table: :employees }
      t.timestamps
    end
  end
end
