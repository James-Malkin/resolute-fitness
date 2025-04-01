# frozen_string_literal: true

class Address < ApplicationRecord
  belongs_to :user, optional: true

  validates :line1, presence: true
  validates :postcode, presence: true
  validates :country, presence: true
  validates :city, presence: true
  validates :county, presence: true
end
