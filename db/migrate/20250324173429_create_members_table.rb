# frozen_string_literal: true

class CreateMembersTable < ActiveRecord::Migration[8.0]
  def change
    create_table :members do |t|
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
