# frozen_string_literal: true

class AddPaymentFieldsToBooking < ActiveRecord::Migration[8.0]
  def change
    add_column :bookings, :payment_intent_id, :string
    add_column :bookings, :payment_status, :string
    add_column :bookings, :paid_at, :datetime
  end
end
