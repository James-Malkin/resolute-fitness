# frozen_string_literal: true

class AddPrivacyToMemberProfile < ActiveRecord::Migration[8.0]
  def change
    add_column :members, :public_profile, :boolean, default: false
  end
end
