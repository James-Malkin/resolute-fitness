# frozen_string_literal: true

class AddPriceToClassSchedules < ActiveRecord::Migration[8.0]
  def change
    add_column :class_schedules, :price, :decimal, precision: 10, scale: 2
  end
end
