# frozen_string_literal: true

class CreateBookingTable < ActiveRecord::Migration[8.0]
  def change
    create_table :bookings do |t|
      t.references :member, null: false, foreign_key: true
      t.references :class_schedule, null: false, foreign_key: true
      t.timestamps
    end
  end
end
