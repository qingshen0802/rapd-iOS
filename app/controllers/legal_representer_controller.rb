class LegalRepresenterController < JsonController
  
  attr_accessor :form_view, :profile  

  def viewDidLoad
    self.title = "Cadastrar responsável"
    self.form_view = FormView.get_form(delegate: self)
    self.view.addSubview(self.form_view)
    self.form_view.place_auto_layout(top: 0, bottom: 0, leading: 0, trailing: 0)
    self.container_view = self.form_view
    self.load_back_button
    self.load_title
    
    super
  end
  
  def finishLegalRepresenter
    self.profile.legal_representer_name = self.outlets["representer_name_field"].text
    self.profile.legal_representer_document_id = self.outlets["representer_document_id_field"].text
    self.profile.legal_representer_email = self.outlets["representer_email_field"].text
    
    manager = ProfileManager.shared_manager
    manager.delegate = self
    manager.update_resource(profile)
  end
  
  def resource_updated(profile)
    # present_main_controller 
    # verifyaccount_controller = VerifyAccountController.new
    # self.navigationController.pushViewController(verifyaccount_controller, animated: true)
    pending_registration_controller = PendingRegistrationController.new
    self.navigationController.pushViewController(pending_registration_controller, animated: true)
  end
  
  def present_account_verification
    self.app_delegate.present_verify_account
  end

end