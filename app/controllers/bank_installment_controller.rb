class BankInstallmentController < JsonController
  
  attr_accessor :profile, :amount, :transaction
  
  def viewDidLoad
    self.title = "Boleto Bancário"
    
    super
    self.load_back_button
    self.load_title
    self.outlets["instructions_label"].text = self.outlets["instructions_label"].text.gsub("[amount]", transaction.readable_amount).gsub("[expires_at]", transaction.expires_at).gsub("[email]", profile.email)
    self.outlets["amount_field"].text = transaction.readable_amount
    self.outlets["expires_at_field"].text = transaction.expires_at
    self.outlets["bank_installment_code_field"].text = transaction.bank_installment_code
  end

  def completeInstallment
    self.navigationController.popToRootViewControllerAnimated(true)
  end

end