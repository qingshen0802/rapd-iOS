class ForgotPasswordController < JsonController

  attr_accessor :form_view

  def viewDidLoad
    self.title = "Esqueci minha senha"
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
  
  def resetPassword
    self.show_loading("Carregando...")
    send_sms_url = "#{app_delegate.base_url}/api/users/reset_password_sms_confirmation.json?phone_number=#{self.outlets["phone_number_field"].text}"
    rest_client = RestClient.new
    response = rest_client.get(send_sms_url, app_delegate.api_access_token)

    self.dismiss_loading
    if !response["user"].nil?
      self.app_delegate.display_message("SMS Enviado", "SMS enviado com código de confirmação")
      confirm_controller = ConfirmAccountController.new
      confirm_controller.phone_ending_number = self.outlets["phone_number_field"].text[-4,4]
      confirm_controller.password_reset = true
      confirm_controller.user_id = response["user"]["id"]
      self.navigationController.pushViewController(confirm_controller, animated: true)
    end
  end
  
end