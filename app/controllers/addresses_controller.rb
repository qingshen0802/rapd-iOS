class AddressesController < JsonController

  attr_accessor :addresses, :profile
  
  def viewDidLoad
    self.title = "Meus endereços"
    super
    load_addresses
    back_button = self.load_back_button
    title_label = self.load_title   
    unless settings[:title_color].nil?
      title_label.textColor = Theme.color(settings[:title_color])
    end
  end
  
  def noContentLabelColor
    UIColor.whiteColor
  end
  
  def load_addresses
    address_manager = AddressManager.shared_manager
    address_manager.delegate = self
    address_manager.fetch_all(profile_id: profile.remote_id)
  end
  
  def items_fetched(addresses)
    self.addresses = addresses
    self.data_table_view.reloadData
  end
  
  def address_rows
    addresses.map{|address|
      {cell_type: "no_icon_title_subtitle", title: address.name, subtitle: address.short_address, id: address.remote_id, action: "select_address", action_param: address, disclosure: true}
    }
  end
  
  def table_data
    if self.addresses.nil? || self.addresses.to_a.count == 0
      []
    else
      [{rows: address_rows}]
    end
  end
  
  def select_address(address)
    address_form = AddressFormController.new
    address_form.profile = profile
    address_form.address = address
    address_form.addresses_controller = self
    self.navigationController.pushViewController(address_form, animated: true)
  end
  
  def addAddress
    address_form = AddressFormController.new
    address_form.profile = profile
    address_form.addresses_controller = self
    self.navigationController.pushViewController(address_form, animated: true)
  end

end