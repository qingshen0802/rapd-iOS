class ConfirmAccountController < JsonController

  attr_accessor :form_view, :phone_ending_number, :password_reset, :user_id
  
  def viewDidLoad
    self.title = "Confirme sua conta"
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
    
    self.outlets["confirm_account_label"].text = self.outlets["confirm_account_label"].text.gsub("[number]", phone_ending_number)
  end
  
  def triggerSmsConfirmation
    self.show_loading("Carregando...")
    send_sms_url = "#{app_delegate.base_url}/api/users/#{current_user.remote_id}/trigger_sms_confirmation.json"
    rest_client = RestClient.new
    response = rest_client.get(send_sms_url, current_user.access_token)

    self.dismiss_loading
    if response["message"] == 'ok'
      self.app_delegate.display_message("SMS Enviado", "Novo SMS enviado com código de confirmação")
    end
  end  
  
  def confirmAccount
    self.show_loading("Carregando...")
    rest_client = RestClient.new    
    
    if password_reset
      confirmation_url = "#{app_delegate.base_url}/api/users/password_reset_confirm_via_sms.json?id=#{user_id}&sms_confirmation_code=#{self.outlets["code_field"].text}"
      response = rest_client.get(confirmation_url, app_delegate.api_access_token)
    else
      confirmation_url = "#{app_delegate.base_url}/api/users/#{current_user.remote_id}/confirm_via_sms.json?sms_confirmation_code=#{self.outlets["code_field"].text}"      
      response = rest_client.get(confirmation_url, current_user.access_token)      
    end
    self.dismiss_loading
    
    if !response["user"].nil? && !response["user"]["sms_confirmed_at"].nil?
      if password_reset
        user = User.new(response["user"].merge(remote_id: response["user"]["id"]))
        store_user_locally(user)
        reset_password_controller = ResetPasswordController.new
        self.navigationController.pushViewController(reset_password_controller, animated: true)
      else
        user = self.current_user
        user.sms_confirmed_at = response["user"]["sms_confirmed_at"].to_s
        store_user_locally(user)
        
        self.screen_manager.present_main
      end
    else
      app_delegate.display_error("Houve um problema ao confirmar o código. Tente novamente")
    end
  end
  
end