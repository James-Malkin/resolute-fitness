# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, ExerciseClass
    can :read, ClassSchedule

    can :view, :profile do |_, target|
      target == user || target.member&.public_profile? || target.employee
    end

    return unless user.present?

    member_permissions(user)
    employee_permissions(user)
  end

  def member_permissions(user)
    return unless user.member.present?

    can :create, Booking
    can :read, Booking, member_id: user.member.id
  end

  def employee_permissions(user)
    return unless user.employee.present?

    can :access, :staff_tools

    can :manage, ExerciseClass
    can :manage, ClassSchedule
  end
end
