# frozen_string_literal: true

class AddSubscriptionAttributesToMember < ActiveRecord::Migration[8.0]
  def change
    add_column :members, :stripe_subscription_id, :string
    add_column :members, :subscription_period_end, :datetime
  end
end
