class EditProfileController < JsonController

  attr_accessor :form_view, :user, :profile, :profile_controller, :profiles_controller, :picker_data

  def viewDidLoad
    self.title = "Meus dados"
    self.form_view = FormView.get_form(delegate: self)
    self.view.addSubview(self.form_view)
    self.form_view.place_auto_layout(top: 0, bottom: 0, leading: 0, trailing: 0)
    self.container_view = self.form_view
    self.load_back_button
    title_label = self.load_title  
    
    super
    self.outlets["birth_date_field"].mask = "##/##/####"
    load_form_for_profile_type
    preload_profile
    unless settings[:title_color].nil?
      title_label.textColor = Theme.color(settings[:title_color])
    end

  end
  
  def textField(textField, shouldChangeCharactersInRange: range, replacementString: string)
    if textField == self.outlets['birth_date_field']
      return self.outlets['birth_date_field'].shouldChangeCharactersInRange(range, replacementString:string)
    else
      true
    end
  end

  def picker_view_data
    if self.picker_data.nil?
      c = RestClient.new
      # self.picker_data = {"category_select" => [[""] + c.get("#{app_delegate.base_url}/api/company_categories/names.json", app_delegate.api_access_token)]}
      self.picker_data = {"category_select" => [[""] + c.get("#{app_delegate.base_url}/api/company_categories/names.json", app_delegate.access_token)]}      
    end
    self.picker_data
  end    
  
  def load_form_for_profile_type
    if profile.profile_type != 'Person'
     # self.outlets["document_id_label"].text = "CNPJ (Não pode ser alterado)"
     # self.outlets["birth_date_label"].hidden = true
      self.outlets["birth_date_field"].hidden = true
    else
     # self.outlets["description_label"].hidden = true
      self.outlets["description_field"].hidden = true
     # self.outlets["category_label"].hidden = true
      self.outlets["category_select"].hidden = true
    end
  end

  def preload_profile
    self.outlets["name_field"].text = self.profile.full_name
    self.outlets["name_field"].textColor = Theme.secondary_color
   # self.outlets["username_field"].text = self.profile.username
   # self.outlets["username_field"].textColor = Theme.secondary_color
   # self.outlets["username_field"].enabled = false
    self.outlets["email_field"].text = self.profile.email
    self.outlets["email_field"].textColor = Theme.secondary_color
    self.outlets["document_id_field"].text = self.profile.document_id
    self.outlets["document_id_field"].textColor = Theme.secondary_color
    self.outlets["document_id_field"].enabled = false
    self.outlets["birth_date_field"].text = self.profile.birth_date
    self.outlets["birth_date_field"].textColor = Theme.secondary_color
    self.outlets["category_select"].text = self.profile.company_category_name
    self.outlets["category_select"].textColor = Theme.secondary_color
  end

  def save
    self.profile.full_name = self.outlets["name_field"].text
    self.profile.email = self.outlets["email_field"].text
    self.profile.birth_date = self.outlets["birth_date_field"].text
    self.profile.company_category_name = self.outlets["category_select"].text
    
    self.show_loading("Carregando...")
    profile_manager = ProfileManager.shared_manager
    profile_manager.delegate = self
    profile_manager.update_resource(self.profile)
  end
  
  def resource_updated(profile)
    self.profile_controller.load_profile
    self.profiles_controller.load_profiles
    self.dismiss_loading
    self.navigationController.popViewControllerAnimated(true)
  end

end