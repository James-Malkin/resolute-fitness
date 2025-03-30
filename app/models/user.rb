# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable

  attr_accessor :login

  has_one :member, dependent: :destroy
  has_one :employee, dependent: :destroy

  has_one_attached :avatar

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
end
