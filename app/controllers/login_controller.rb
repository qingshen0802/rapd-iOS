class LoginController < JsonController
  
  attr_accessor :form_view
  
  def viewDidLoad
    self.title = "Acesse sua conta"
    self.form_view = FormView.get_form(delegate: self)
    self.view.addSubview(self.form_view)
    self.form_view.place_auto_layout(top: 0, bottom: 0, leading: 0, trailing: 0)
    self.container_view = self.form_view
    self.load_back_button
    title_label = self.load_title  

    super
  end

  def login
    manager = LoginManager.shared_manager
    manager.delegate = self
    manager.login(self.outlets["email_field"].text, self.outlets["password_field"].text)
  end
  
  def logged_in
    screen_manager.start
  end
  
  def login_failed
  end

  def forgotPassword
    self.navigationController.pushViewController(ForgotPasswordController.new, animated: true)
  end

end