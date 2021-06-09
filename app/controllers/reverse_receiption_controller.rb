class ReverseReceiptionController < JsonController
attr_accessor :form_view, :transaction  

  def viewDidLoad
    self.title = "Estornar Valor"
    self.form_view = FormView.get_form(delegate: self)
    self.view.addSubview(self.form_view)
    self.form_view.place_auto_layout(top: 0, bottom: 0, leading: 0, trailing: 0)
    self.container_view = self.form_view
    self.load_title
    self.load_back_button
    super
  end
  
  def reverse_receiption
    p transaction.amount
  end
    
end
