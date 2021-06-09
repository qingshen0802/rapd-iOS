class ResetPasswordController < JsonController

  attr_accessor :form_view, :from_profile

  def viewDidLoad
    self.title = "Redefinir Senha"
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
  end
  
  def confirmResetPassword
    user = self.current_user
    user.password = self.outlets["password_field"].text
    user.password_confirmation = self.outlets["confirm_password_field"].text
    
    self.show_loading("Carregando...")
    user_manager = UserManager.shared_manager
    user_manager.delegate = self
    user_manager.update_resource(user)
  end

  def resource_updated(user)
    self.dismiss_loading
    self.app_delegate.display_message("Senha Alterada", "Sua senha foi alterada com sucesso")        
    if from_profile
      self.navigationController.popViewControllerAnimated(true)
    else
      self.screen_manager.present_main
    end
  end

end