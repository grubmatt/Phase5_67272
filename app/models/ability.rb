class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.role? :admin
      can :manage, :all
    elsif user.role? :manager
      can :read, [Store, Job, Flavor]
      can :read, Employee do |employee|
        employee.current_assignment.store_id = user.store_id
      end
      can :read, Assignment do |assignment|
        current_assignment.store_id = user.store_id
      end
      can :crud, Shift do |shift|
        shift.store.id = user.store_id
      end
      can [:read, :create, :destroy], ShiftJob do |shiftjob|
        shiftjob.shift.current_assignment.store_id = user.store_id
      end
      can [:read, :create, :destroy], StoreFlavor do |storeflavor|
        storeflavor.store.id = user.store_id
      end
    elsif user.role? :employee
      can :read, [Store, Job, Flavor]
      can :read, Employee, :id => user.employee_id
      can :read, User, :id => user.id
      can :read, Assignment, :id => user.employee.current_assignment.id
      can :read, Shift do |shift|
        shift.assignment.id = user.employee.current_assignment.id
      end 
    else
      can :read, Store
    end
  end
end
