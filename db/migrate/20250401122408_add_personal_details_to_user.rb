# frozen_string_literal: true

class AddPersonalDetailsToUser < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :date_of_birth, :date
    add_column :users, :phone_number, :string

    create_table :addresses do |t|
      t.string :line1, null: false
      t.string :line2
      t.string :city
      t.string :county
      t.string :postcode
      t.string :country, null: false, default: 'UK'
    end

    add_reference :addresses, :user, foreign_key: true
  end
end
