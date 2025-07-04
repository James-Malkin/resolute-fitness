# frozen_string_literal: true

class AddClassesTable < ActiveRecord::Migration[8.0]
  def change
    create_table :classes do |t|
      t.string :name, null: false
      t.string :description
      t.timestamps
    end
  end
end
