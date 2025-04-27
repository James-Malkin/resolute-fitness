# frozen_string_literal: true

class AddPlanToMember < ActiveRecord::Migration[8.0]
  def change
    add_column :members, :plan, :integer, default: 0, null: false
  end
end
