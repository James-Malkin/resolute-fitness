# frozen_string_literal: true

class AddStripeIdToMember < ActiveRecord::Migration[8.0]
  def change
    add_column :members, :stripe_customer_id, :string
    add_index :members, :stripe_customer_id, unique: true
  end
end
