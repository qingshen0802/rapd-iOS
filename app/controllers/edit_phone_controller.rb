class EditPhoneController < JsonController

  attr_accessor :form_view, :user, :profile

  def viewDidLoad
    self.title = "Meu telefone"
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

    self.outlets["phone_field"].text = self.current_user.phone_number
    self.outlets["phone_field"].textColor = Theme.secondary_color
  end

  def save
    user = self.current_user
    user.phone_number = self.outlets["phone_field"].text

    self.show_loading("Carregando...")
    user_manager = UserManager.shared_manager
    user_manager.delegate = self
    user_manager.update_resource(user)
  end
  
  def resource_updated(user)
    store_user_locally(user)
    self.dismiss_loading
    self.navigationController.popViewControllerAnimated(true)
  end

end