class RequestPrepaidCardController < JsonController

  attr_accessor :addresses, :selected_address

  def viewDidLoad
    self.addresses = []
    self.title = "Solicite Agora"
    self.load_back_button
    title_label = self.load_title
    super
    unless settings[:title_color].nil?
      title_label.textColor = Theme.color(settings[:title_color])
    end
    load_addresses
  end

  def load_addresses
    address_manager = AddressManager.shared_manager
    address_manager.delegate = self
    address_manager.fetch_all(profile_id: profile.remote_id)
  end

  def items_fetched(addresses)
    self.addresses = addresses
    self.outlets["address_select"].picker_view.reloadData
  end  

  def address_options
    addresses.map(&:name)
  end
  
  def picker_view_data
    {"address_select" => [address_options]}
  end
  
  def pickerView(pickerView, didSelectRow:row, inComponent:component)
    super(pickerView, didSelectRow:row, inComponent:component)
    address_name = picker_view_data["address_select"].first[row]
    self.selected_address = addresses.map{|a| a if a.name == address_name}.compact.first
  end
  
  def requestCard
    request = PrepaidCardRequest.new
    request.address_id = self.selected_address.remote_id
    request.profile_id = self.profile.remote_id
    
    manager = PrepaidCardRequestManager.shared_manager
    manager.delegate = self
    manager.create_resource(request)
    self.outlets["save_button"].enabled = false
  end
  
  def resource_created(resource)
    self.app_delegate.display_message("Sucesso", "Seu cartão RapdIn foi solicitado com sucesso!")
    self.navigationController.popToRootViewControllerAnimated(true)
  end

end