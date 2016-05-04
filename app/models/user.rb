class User < ActiveRecord::Base
  # get modules to help with some functionality
  include CreameryHelpers::Validations

  has_secure_password
  after_save :employee_is_active_in_system

  # Relationships
  belongs_to :employee

  # Validations
  validates_uniqueness_of :email, case_sensitive: false
  validates_format_of :email, :with => /\A[\w]([^@\s,;]+)@(([\w-]+\.)+(com|edu|org|net|gov|mil|biz|info))\z/i, :message => "is not a valid format"

  def self.authenticate(email,password)
    find_by_email(email).try(:authenticate, password)
  end

  def role?(authorized_role)
    role = self.employee.role unless self.employee == nil
    return false if role.nil?
    role.to_sym == authorized_role
  end

  def store_id
    self.employee.current_assignment.store_id unless self.employee.current_assignment == nil
  end

  private
  def employee_is_active_in_system
    is_active_in_system(:employee)
  end

end
