# frozen_string_literal: true

class CreateEmployeesTable < ActiveRecord::Migration[8.0]
  def change
    create_table :employees do |t|
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
