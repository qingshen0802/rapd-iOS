class AccountController < JsonController
  
  attr_accessor :profile, :image_picker, :profile_controller, :profiles_controller
  
  def viewDidLoad
    self.navigationController.navigationBar.hidden = true
    self.title = "Meu perfil"
    self.table_data = load_table_data
    super
    
    back_button = self.load_back_button
    unless settings[:back_button].nil?
      back_button.setImage(UIImage.imageNamed(settings[:back_button]), forState: UIControlStateNormal)
    end
        
    title_label = self.load_title
    unless settings[:title_color].nil?
      title_label.textColor = Theme.color(settings[:title_color])
    end
    
    load_profile
  end
  
  def load_table_data
    profile_photo = profile.photo_url if !profile.nil? && !profile.photo_url.nil?
    profile_photo = "https://graph.facebook.com/#{current_user.facebook_id}/picture?width=9999" if (!current_user.facebook_id.nil? && profile_photo.to_s.length == 0) || profile_photo =~ /missing/

    [
      {rows: [
        {cell_type: "profile_top", profile_name: self.profile.try(:full_name), profile_username: "@#{self.profile.try(:username)}", profile_photo: profile_photo, update_photo: true, photo: profile.photo},
        {cell_type: "icon_title_subtitle", icon: "images/account_pencil_icon.png", title: "Meus dados", subtitle: "Edite suas informações básicas", disclosure: true, action: "displayEditInfo"},
        {cell_type: "icon_title_subtitle", icon: "images/account_phone_icon.png", title: "Meu telefone", subtitle: "Mantenha seu número de celular atualizado", disclosure: true, action: "displayEditPhone"},
        {cell_type: "icon_title_subtitle", icon: "images/account_home_icon.png", title: "Meus endereços", subtitle: "Confirme seus endereços", disclosure: true, action: "displayManageAddresses", action_param: profile},
        {cell_type: "icon_title_subtitle", icon: "images/account_document_icon.png", title: "Meus documentos", subtitle: "Confirme sua identidade", disclosure: true, action: "displayManageDocuments"},
        # {cell_type: "icon_title_subtitle", icon: "images/account_network_icon.png", title: "Redes Sociais", subtitle: "Um pouco mais sobre você", disclosure: true, action: "displaySocialNetworks"},
        {cell_type: "icon_title_subtitle", icon: "images/account_bank_icon.png", title: "Meus dados bancários", subtitle: "Informe os dados do seu banco", disclosure: true, action: "displayManageBankAccounts"}
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
    #p self.profile.photo
    self.table_data = load_table_data    
    self.data_table_view.reloadData
  end
  
  def showProfiles
    self.menuContainerViewController.toggleRightSideMenuCompletion(lambda{
      # puts "Toggled"
    })
  end
  
  def selectPhoto
    self.image_picker = UIImagePickerController.new
    self.image_picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary
    self.image_picker.delegate = self
    self.presentViewController(image_picker, animated: true, completion: nil)
  end
  
  def imagePickerController(picker, didFinishPickingMediaWithInfo: imageInfo)
    extension = imageInfo[UIImagePickerControllerReferenceURL].absoluteString.split("=").last
    self.profile.photo = imageInfo[UIImagePickerControllerOriginalImage]
    self.profile.photo_mime_type = extension == "JPG" ? "image/jpeg" : "image/png"
    self.table_data = load_table_data
    self.data_table_view.reloadData
    self.image_picker.dismissViewControllerAnimated(true, completion: nil)
    save_profile
  end  
  
  def save_profile
    p 'save_profile'
    p self.profile
    self.show_loading("Carregando...")
    profile_manager = ProfileManager.shared_manager
    profile_manager.delegate = self
    profile_manager.update_resource(self.profile)
  end
  
  def resource_updated(profile)
    p 'resource_updated'
    self.profile_controller.load_profile
    self.profiles_controller.load_profiles
    self.dismiss_loading    
  end
  
  def displayEditInfo
    edit_controller = EditProfileController.new
    edit_controller.profile = profile
    edit_controller.profile_controller = self
    edit_controller.profiles_controller = profiles_controller
    self.navigationController.pushViewController(edit_controller, animated: true)
  end
  
  def displayEditPhone
    edit_controller = EditPhoneController.new
    self.navigationController.pushViewController(edit_controller, animated: true)
  end
  

  
  def displayManageAddresses(profile)
    addresses_controller = AddressesController.new
    addresses_controller.profile = profile
    self.navigationController.pushViewController(addresses_controller, animated: true)    
  end
  
  def displayManageDocuments
    document_controller = DocumentCheckController.new
    document_controller.profile = profile
    self.navigationController.pushViewController(document_controller, animated: true)
  end
  
 # def displaySocialNetworks
 #   social_networks_contoller = SocialNetworksController.new
 #   social_networks_contoller.profile = self.profile
 #   self.navigationController.pushViewController(social_networks_contoller, animated: true)
 # end
  
  def displayManageBankAccounts
    bank_account_controller = BankAccountController.new
    bank_account_controller.profile = profile
    bank_account_controller.account_controller = self
    self.navigationController.pushViewController(bank_account_controller, animated: true)
  end
  
end