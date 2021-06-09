class AddressFormController < JsonController
  
  attr_accessor :profile, :addresses_controller, :address, :address_id, :form_view
  
  def viewDidLoad
    self.address = Address.new if address.nil?    
    self.title = address.new_record? ? "Novo endereço" : "Alterar endereço"

    self.form_view = FormView.get_form(delegate: self)
    self.view.addSubview(self.form_view)
    self.form_view.place_auto_layout(top: 0, bottom: 0, leading: 0, trailing: 0)
    self.container_view = self.form_view
    self.load_back_button
    title_label = self.load_title  
    
    super
    
    preload_address unless address.new_record?
  end

  def preload_address
    self.outlets["name_field"].text = self.address.name
    self.outlets["name_field"].textColor = Theme.secondary_color
    self.outlets["address_line_1_field"].text = self.address.address_line_1
    self.outlets["address_line_1_field"].textColor = Theme.secondary_color
    self.outlets["address_line_2_field"].text = self.address.address_line_2
    self.outlets["address_line_2_field"].textColor = Theme.secondary_color
    self.outlets["address_line_3_field"].text = self.address.address_line_3
    self.outlets["address_line_3_field"].textColor = Theme.secondary_color
    self.outlets["borough_field"].text = self.address.borough
    self.outlets["borough_field"].textColor = Theme.secondary_color
    self.outlets["city_field"].text = self.address.city
    self.outlets["city_field"].textColor = Theme.secondary_color
    self.outlets["state_field"].text = self.address.state
    self.outlets["state_field"].textColor = Theme.secondary_color
    self.outlets["postal_code_field"].text = self.address.postal_code
    self.outlets["postal_code_field"].textColor = Theme.secondary_color
   # self.outlets["default_address_button"].state(self.address.default_address, animated: false)

  end
  
  def save
    self.address.name = self.outlets["name_field"].text
    self.address.address_line_1 = self.outlets["address_line_1_field"].text
    self.address.address_line_2 = self.outlets["address_line_2_field"].text
    self.address.address_line_3 = self.outlets["address_line_3_field"].text
    self.address.borough = self.outlets["borough_field"].text
    self.address.city = self.outlets["city_field"].text
    self.address.state = self.outlets["state_field"].text
    self.address.postal_code = self.outlets["postal_code_field"].text
    self.address.profile_id = self.profile.remote_id
    
    address_manager = AddressManager.shared_manager
    address_manager.delegate = self
    self.show_loading("Carregando...")
    
    if address.new_record?
      address_manager.create_resource(address)
    else
      address_manager.update_resource(address)
    end
  end
  
#  def toggle_default_address(switch)
#    self.address.default_address = switch.isOn
#  end

  def toggle_default_address
    self.address.default_address = !self.default_address
    self.outlets["default_address_button"].setBackgroundColor(UIColor.colorWithPatternImage(UIImage.imageNamed("images/checkbox#{accepts_terms ? "-checked" : ""}.png")), forState: UIControlStateNormal)    
  end
  
  def resource_created(address)
    self.address = address
    self.addresses_controller.load_addresses
    self.app_delegate.display_message("Endereço Criado", "Seu endereço foi adicionado com sucesso")
    
    self.navigationController.popViewControllerAnimated(true)
  end
  
  def resource_updated(address)
    self.address = address
    self.addresses_controller.load_addresses
    self.app_delegate.display_message("Endereço Atualizado", "Seu endereço foi atualizado com sucesso")
    
    self.navigationController.popViewControllerAnimated(true)
  end
  
end