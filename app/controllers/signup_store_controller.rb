class SignupStoreController < JsonController

  attr_accessor :form_view, :user, :profile, :is_legal_representer, 
                :accepts_terms, :image_picker, :selected_photo, 
                :selected_photo_mime_type, :modal, :skip_facebook,
                :profile_controller, :profiles_controller
  
  def viewDidLoad
    self.title = "Nova Loja"
    self.user = User.new
    self.profile = Profile.new
    self.form_view = FormView.get_form(delegate: self)
    self.view.addSubview(self.form_view)

    button = UIButton.new
    self.view.addSubview(button)
    button.place_auto_layout(top: 20, leading: 10, width: 35, height: 35)
    button.setImage(UIImage.imageNamed("images/back-button.png"), forState: UIControlStateNormal)
    button.addTarget(self, action: NSSelectorFromString("done_with_b"), forControlEvents: UIControlEventTouchUpInside)

    self.form_view.place_auto_layout(top: 0, bottom: 0, leading: 0, trailing: 0)
    self.container_view = self.form_view
    self.load_title 
    
    super
    
    self.outlets['document_id_field'].mask = "##.###.###/####-##"
  end  

  def done_with_b
    self.dismissViewControllerAnimated true, completion:nil
  end
    
  def toggleLegalRepresenter
    self.is_legal_representer = !self.is_legal_representer
    self.outlets["is_legal_representer"].setBackgroundColor(UIColor.colorWithPatternImage(UIImage.imageNamed("images/checkbox#{is_legal_representer ? "-checked" : ""}.png")), forState: UIControlStateNormal)
  end
  
  def toggleAcceptTerms
    self.accepts_terms = !self.accepts_terms
    self.outlets["accept_terms_button"].setBackgroundColor(UIColor.colorWithPatternImage(UIImage.imageNamed("images/checkbox#{accepts_terms ? "-checked" : ""}.png")), forState: UIControlStateNormal)    
  end

  def selectPhoto
    self.image_picker = UIImagePickerController.new
    self.image_picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary
    self.image_picker.delegate = self
    self.presentViewController(image_picker, animated: true, completion: nil)
  end
  
  def imagePickerController(picker, didFinishPickingMediaWithInfo: imageInfo)
    extension = imageInfo[UIImagePickerControllerReferenceURL].absoluteString.split("=").last
    self.selected_photo = imageInfo[UIImagePickerControllerOriginalImage]
    self.selected_photo_mime_type = extension == "JPG" ? "image/jpeg" : "image/png"
    self.outlets["profile_image"].image = self.selected_photo
    self.image_picker.dismissViewControllerAnimated(true, completion: nil)
  end
  

  def finish_signup
    unless self.accepts_terms
      self.app_delegate.display_error("Você precisa aceitar os termos pra continuar.")
    else
      self.outlets["finish_signup_button"].enabled = false
      self.show_loading("Carregando...")
      
      if profile.new_record?
        create_profile        
      else
        update_profile
      end
    end
  end

  def resource_created(resource)
    self.profile = resource
    store_profile_locally(resource)

    self.app_delegate.set_current_profile_id(profile.remote_id)
    self.profile_controller.load_profile
    self.profiles_controller.load_profiles
    self.dismissViewControllerAnimated(true, completion: nil)
  end
  
  def create_profile
    profile = Profile.new({
      profile_type: 'Company',
      username: self.outlets["username_field"].text,
      full_name: self.outlets["name_field"].text,
      document_id: self.outlets["document_id_field"].text,
      user_id: self.current_user.remote_id,
      email: self.outlets["email_field"].text,
      is_legal_representer: self.is_legal_representer,
      accepts_terms: "1"
    })
    
    unless self.selected_photo.nil?
      profile.photo = self.selected_photo
      profile.photo_mime_type = self.selected_photo_mime_type
    end

    profile_manager = ProfileManager.new
    profile_manager.prefix = "/"
    profile_manager.prepare_mapping(profile_manager.prefix)
    profile_manager.delegate = self
    profile_manager.create_resource(profile)
  end
  
  def update_profile
    self.profile.full_name = self.outlets["name_field"].text
    self.profile.is_legal_represented = self.underage ? "1" : "0",

    unless self.selected_photo.nil?
      self.profile.photo = self.selected_photo
      self.profile.photo_mime_type = self.selected_photo_mime_type
    end

    profile_manager = ProfileManager.shared_manager
    profile_manager.delegate = self
    profile_manager.update_resource(profile)
  end  

  def resource_updated(profile)
    self.dismissViewControllerAnimated(true)
  end

  def resource_creation_failed
    self.outlets["finish_signup_button"].enabled = true
  end

  def view_terms
    app_delegate.screen_manager.present_terms(self)
  end
  
  def textField(textField, shouldChangeCharactersInRange: range, replacementString: string)
    if textField == self.outlets['document_id_field']
      return self.outlets['document_id_field'].shouldChangeCharactersInRange(range, replacementString:string)
    else
      true
    end
  end

end