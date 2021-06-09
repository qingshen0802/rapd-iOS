class ProfileController < JsonController
  
  attr_accessor :profile, :profiles_controller

  def viewDidLoad
    self.navigationController.navigationBar.hidden = true
    self.title = "Outras"
    #self.window_title = ""
    self.table_data = load_table_data
    super
    load_profile
  end

  def load_table_data
    profile_photo = profile.photo_url if !profile.nil? && !profile.photo_url.nil?
    profile_photo = "https://graph.facebook.com/#{current_user.facebook_id}/picture?width=9999" if (!current_user.facebook_id.nil? && profile_photo.to_s.length == 0) || profile_photo =~ /missing/

    [
      {rows: [
        {cell_type: "profile_top", profile_name: self.profile.try(:full_name), profile_username: "@#{self.profile.try(:username)}", profile_photo: profile_photo, profile_type: "Perfil #{translate(self.profile.try(:profile_type))}", show_gear: true},
        {cell_type: "icon_title_subtitle", icon: "images/profile_account_icon.png", title: "Meu perfil", subtitle: "Dados pessoais, endereço, etc", disclosure: true, action: "displayAccount"},
      # {cell_type: "icon_title_subtitle", icon: "images/profile_network_icon.png", title: "Meus contatos", subtitle: "Suas indicações, funcionários, etc", disclosure: true, action: "displayNetwork"},
        {cell_type: "icon_title_subtitle", icon: "images/profile_money_icon.png", title: "Operações financeiras", subtitle: "Carregar dinheiro, pagar contas, etc", disclosure: true, action: "displayWalletActions"},
        {cell_type: "icon_title_subtitle", icon: "images/profile_settings_icon.png", title: "Configurações", subtitle: "Altere suas configurações de segurança, etc", disclosure: true, action: "displaySettings"},
        {cell_type: "icon_title_subtitle", icon: "images/profile_rapd_icon.png", title: "Tratto", subtitle: "Maiores informações, ajuda, etc", disclosure: true, action: "displayContact"}
      ]}
    ]
  end
  
  def load_profile
    profile_manager = ProfileManager.new
    profile_manager.prefix = "/"
    profile_manager.prepare_mapping(profile_manager.prefix)
    profile_manager.delegate = self
    profile_manager.fetch(app_delegate.current_profile_id)
  end
  
  def item_fetched(profile)
    self.profile = profile
    self.table_data = load_table_data    
    self.data_table_view.reloadData if self.data_table_view.present? # if the controller was not initialized yet, the tableview will not be avaialble
  end
  
  def showProfiles
    self.menuContainerViewController.toggleRightSideMenuCompletion(lambda{
      # puts "Toggled"
    })
  end
  
  def displayAccount
    account_controller = AccountController.new
    account_controller.profile = profile
    account_controller.profile_controller = self
    account_controller.profiles_controller = profiles_controller
    self.navigationController.pushViewController(account_controller, animated: true)
  end
  
#  def displayNetwork
#    network_controller = NetworkController.new
#    network_controller.profile = profile
#    self.navigationController.pushViewController(network_controller, animated: true)
#  end
  
  def displayWalletActions
    manage_wallet_controller = ManageWalletController.new
    manage_wallet_controller.profile = profile
    self.navigationController.pushViewController(manage_wallet_controller, animated: true)    
  end
  
  def displaySettings
    manage_wallet_controller = SettingsController.new
    manage_wallet_controller.profile = profile
    self.navigationController.pushViewController(manage_wallet_controller, animated: true)
  end
  
  
  def displayContact
    controller = ContactController.new
    controller.profile = profile
    self.navigationController.pushViewController(controller, animated: true)
  end
  
  def translate(profile_type)
    case profile_type
    when 'Person'
      "Usuário"
    when 'Company'
      "Lojista"
    else
      profile_type
    end
  end
end