# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :validatable, :confirmable

  attr_accessor :login

  delegate :plan, to: :member, prefix: true, allow_nil: true

  has_one :member, dependent: :destroy
  has_one :employee, dependent: :destroy

  has_one :address, dependent: :destroy
  accepts_nested_attributes_for :address, allow_destroy: true

  has_one_attached :avatar

  validates :username, presence: true, uniqueness: { case_sensitive: false },
                       length: { minimum: 3, maximum: 20 },
                       format: { with: /\A[a-zA-Z0-9\-]+\z/, message: 'can only contain letters, numbers, and hyphens' }

  scope :by_username, ->(username) { find_by!(username: username) }

  # validates :avatar, content_type: { in: %w[image/png image/jpg image/jpeg] }, size: { less_than: 5.megabytes }, if: -> { avatar.attached? }

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    login = conditions.delete(:login)

    return nil unless login

    where(conditions.to_h).where(
      ['lower(username) = :value OR lower(email) = :value',
       { value: login.downcase }]
    ).first
  end

  def cancel_change_email!
    self.unconfirmed_email = nil
    self.confirmation_token = nil
    save!
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end
