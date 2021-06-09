class SignupController < JsonController

  attr_accessor :form_view, :user, :profile, :underage, 
                :accepts_terms, :image_picker, :selected_photo, 
                :selected_photo_mime_type

  def viewDidLoad
    self.navigationController.navigationBar.hidden = true
    
    self.title = "Novo perfil"
    self.user = User.new
    self.profile = Profile.new if profile.nil?
    self.form_view = FormView.get_form(delegate: self)
    self.view.addSubview(self.form_view)
    self.form_view.place_auto_layout(top: 0, bottom: 0, leading: 0, trailing: 0)
    self.container_view = self.form_view
    self.load_back_button
    title_label = self.load_title
    
    super
    
    unless settings[:title_color].nil?
      title_label.textColor = Theme.color(settings[:title_color])
    end
    
    self.outlets['document_id_field'].mask = "###.###.###-##"
    
    preload_facebook
    preload_profile
    preload_photo
  end
  
  def viewDidAppear(animated)
    super(animated)
    self.outlets["finish_signup_button"].enabled = true
    if !current_user.nil?
      self.outlets["password_field"].hidden = true
      self.outlets["confirm_password_field"].hidden = true
    end
  end
  
  def preload_facebook
    if !current_user.nil? && !current_user.facebook_id.nil?
      if SCFacebook.isSessionValid
        SCFacebook.getUserFields("email,first_name,last_name,picture,gender", callBack: lambda{|profile_success, profile_result|
          if profile_success
            self.profile.full_name = "#{profile_result["first_name"]} #{profile_result["last_name"]}"
            self.profile.email = profile_result["email"]
            preload_profile
            preload_photo            
          end
        })        
      else
        SCFacebook.loginCallBack(lambda{|success, result|
          if success
            preload_facebook
          else
            app_delegate.display_error("Houve um erro na autenticação com o Facebook")
            self.app_delegate.set_user(nil)
            self.screen_manager.present_launch
          end
        })
      end
    end
  end  
  
  def preload_profile
    unless profile.nil?
      self.outlets["name_field"].text = self.profile.full_name
      self.outlets["email_field"].text = self.profile.email
    end
  end
  
  def preload_photo
    unless current_user.nil?
      if !current_user.facebook_id.nil?
        profile_photo_url = "https://graph.facebook.com/#{current_user.facebook_id}/picture?width=9999"
        self.outlets["profile_image"].sd_setImageWithURL(NSURL.URLWithString(profile_photo_url), placeholderImage: UIImage.imageNamed("images/profile_placeholder.png"))
      elsif !profile.nil? && !profile.photo_url.nil?
        self.outlets["profile_image"].sd_setImageWithURL(NSURL.URLWithString(profile.photo_url), placeholderImage: UIImage.imageNamed("images/profile_placeholder.png"))
      end
    end
  end

  def canEdit?(textField)
    if self.profile.nil? || self.profile.new_record?
      return true
    else
      data = self.outlet_data[textField]
      if ['username_field', 'email_field', 'password_field', 'confirm_password_field', 'document_id_field'].include?(data[:outlet])
        return false
      else
        return true
      end
    end
  end
  
  def toggleUnderAge
    self.underage = !self.underage
    self.outlets["age_button"].setBackgroundColor(UIColor.colorWithPatternImage(UIImage.imageNamed("images/checkbox#{underage ? "-checked" : ""}.png")), forState: UIControlStateNormal)
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
      self.user = User.new({
        email: self.outlets["email_field"].text,
        password: self.outlets["password_field"].text,
        password_confirmation: self.outlets["confirm_password_field"].text
      })
      
      self.outlets["finish_signup_button"].enabled = false
      self.show_loading("Carregando...")
      
      manager = UserManager.shared_manager    
      manager.delegate = self
      
      if self.current_user.nil?
        manager.create_resource(user)
      else
        if profile.new_record?
          create_profile        
        else
          update_profile
        end
      end
    end
  end

  def resource_created(resource)
    if resource.is_a?(User)
      store_user_locally(resource)
      create_profile
    elsif resource.is_a?(Profile)
      self.profile = resource
      store_profile_locally(resource)
      store_user_device
    elsif resource.is_a?(UserDevice)
      user_device_created
    end
  end
  
  def create_profile
    profile = Profile.new({
      profile_type: 'Person',
      username: self.outlets["username_field"].text,
      full_name: self.outlets["name_field"].text,
      document_id: self.outlets["document_id_field"].text,
      user_id: self.current_user.remote_id,
      email: self.outlets["email_field"].text,
      is_legal_represented: self.underage ? "1" : "0",
      accepts_terms: "1"
    })
    
    unless self.selected_photo.nil?
      profile.photo = self.selected_photo
      profile.photo_mime_type = self.selected_photo_mime_type
    end

    profile_manager = ProfileManager.shared_manager
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
    if self.profile.is_legal_represented
      present_legal_representer_form
    else
      present_account_verification
    end    
  end

  def resource_creation_failed
    dismiss_loading
    self.outlets["finish_signup_button"].enabled = true
  end
  
  def user_device_created
    if self.profile.is_legal_represented
      present_legal_representer_form
    else
      present_account_verification
    end
  end

  def present_legal_representer_form
    representer_controller = LegalRepresenterController.new
    representer_controller.profile = self.profile
    self.navigationController.pushViewController(representer_controller, animated: true)
  end
  
  def present_account_verification
    self.screen_manager.present_verify_account
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