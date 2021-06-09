class ContactsController < JsonController

  attr_accessor :contacts, :profile, :query, :manage_employees, :contact_manager
  
  def viewDidLoad
    self.title = manage_employees ? "Meus funcionários" : "Meus contatos"
    super
    load_contacts
    back_button = self.load_back_button
    title_label = self.load_title   
     unless settings[:title_color].nil?
      title_label.textColor = Theme.color(settings[:title_color])
    end
  end
  
  def noContentLabelColor
    UIColor.whiteColor
  end
  
  def performSearch
    load_contacts
  end
  
  def load_contacts
    self.contact_manager = ContactManager.shared_manager
    self.contact_manager.delegate = self
    contact_manager.fetch_all(profile_id: profile.remote_id, query: query)
  end
  
  def items_fetched(contacts)
    self.contacts = contacts
    self.data_table_view.reloadData
  end
  
  def contacts_rows
    contacts.map{|contact|
      profile_photo = contact.contact.photo_url if !contact.contact.nil? && !contact.contact.photo_url.nil?
      {
        cell_type: "profile", 
        name: contact.contact.full_name, 
        username: contact.contact.username, 
        photo: profile_photo, 
        id: contact.remote_id, 
        profile_type: contact.contact.profile_type, 
        is_employee: contact.is_employee, 
        manage_employees: manage_employees, 
        action: (manage_employees ? "toggle_employee" : "select_profile"), 
        action_param: (manage_employees ? contact : contact.contact), 
        inverse: true, 
        disclosure: !manage_employees
      }
    }
  end
  
  def table_data
    if self.contacts.nil? || self.contacts.to_a.count == 0
      []
    else
      [{rows: contacts_rows}]
    end
  end
  
  def show_profile(profile)
    public_profile_form = PublicProfileForm.new
    public_profile_form.profile = profile
    self.navigationController.pushViewController(public_profile_form, animated: true)
  end
  
  def toggle_employee(contact)
    contact.is_employee = !contact.is_employee
    self.contact_manager.update_resource(contact)
  end
  
  def resource_updated(contact)
    load_contacts
  end

end