# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, ExerciseClass
    can :read, ClassSchedule

    return unless user.present?

    if user.member.present?
      can :create, Booking
      can :read, Booking, member_id: user.member.id
    end

    return unless user.employee.present?

    can :access, :staff_tools

    can :manage, ExerciseClass
    can :manage, ClassSchedule
  end
end
