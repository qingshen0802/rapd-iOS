class PendingRegistrationController < JsonController
  
  attr_accessor :form_view, :profile  

  def viewDidLoad
    self.title = "Pending registration"
    self.form_view = FormView.get_form(delegate: self)
    self.view.addSubview(self.form_view)
    self.form_view.place_auto_layout(top: 0, bottom: 0, leading: 0, trailing: 0)
    self.container_view = self.form_view
    self.load_title
    
    super
  end
  
  def logout
    self.app_delegate.logout
  end

end