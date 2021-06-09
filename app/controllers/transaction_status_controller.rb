class TransactionStatusController < JsonController
  
  attr_accessor :profile, :transaction
  
  def viewDidLoad
    self.title = transaction.approved? ? "Sucesso!" : "Erro!"
    super
    self.load_title
    self.outlets["status_icon"].image = UIImage.imageNamed("images/transaction_status_#{transaction.approved? ? "success" : "error"}.png")
    
    success_message = "Compra realizada com sucesso. Enviamos um email para você com o detalhes dessa compra.\n\nNenhuma informação foi armazenada para sua segurança.\n\nObrigado!"
    error_message = "Ops! Algo deu errado com a sua compra, favor tentar novamente. Se o problema persistir entre em contato com a empresa responsável para maiores informações.\n\n\nObrigado!"
    
    self.outlets["status_label"].text = transaction.approved? ? success_message : error_message
  end
  
  def finish
    if self.transaction.approved?
      self.navigationController.popToRootViewControllerAnimated(true)      
    else
      self.navigationController.popViewControllerAnimated(true)      
    end
  end
  
end