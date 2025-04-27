# frozen_string_literal: true

class StoreDefaultPaymentOnMember < ActiveRecord::Migration[8.0]
  def change
    add_column :members, :default_payment_method_id, :string
  end
end
