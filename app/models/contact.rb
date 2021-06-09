class Contact < BaseEntity

  attr_accessor :profile_id, :contact_id, :user_id, :contact, :is_employee
  
  def full_name
    contact.full_name
  end

end