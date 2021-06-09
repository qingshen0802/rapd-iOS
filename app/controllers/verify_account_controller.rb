class VerifyAccountController < JsonController

  attr_accessor :form_view

  def viewDidLoad
    self.navigationController.navigationBar.hidden = true
    self.title = "Verificação de telefone"
    self.form_view = FormView.get_form(delegate: self)
    self.view.addSubview(self.form_view)
    self.form_view.place_auto_layout(top: 0, bottom: 0, leading: 0, trailing: 0)
    self.container_view = self.form_view
    title_label = self.load_title
    self.load_back_button

    
    super
    
    self.outlets['phone_number_field'].mask = "(##) #####-####"

    unless settings[:title_color].nil?
      title_label.textColor = Theme.color(settings[:title_color])
    end
    
  end
    
  def verifyAccount
    if self.outlets["phone_number_field"].text != ""
      user = self.current_user
      user.phone_number = self.outlets["phone_number_field"].text
      
      self.show_loading("Carregando...")
      user_manager = UserManager.shared_manager
      user_manager.delegate = self
      user_manager.update_resource(user)
    else
      self.app_delegate.display_message("Error","Please input valid PhoneNumber")
    end
    
  end
  
  def resource_updated(resource)
    self.dismiss_loading
    store_user_locally(resource)
    confirm_controller = ConfirmAccountController.new
    confirm_controller.phone_ending_number = self.outlets["phone_number_field"].text[-4,4]
    self.navigationController.pushViewController(confirm_controller, animated: true)
  end
  
  def textField(textField, shouldChangeCharactersInRange: range, replacementString: string)
    if textField == self.outlets['phone_number_field']
      return self.outlets['phone_number_field'].shouldChangeCharactersInRange(range, replacementString:string)
    else
      true
    end
  end

  def verifycode
    confirm_controller = ConfirmAccountController.new
    confirm_controller.phone_ending_number = self.current_user.phone_number
    self.navigationController.pushViewController(confirm_controller, animated: true)
  end
    
end