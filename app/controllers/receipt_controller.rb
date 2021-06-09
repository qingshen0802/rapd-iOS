class ReceiptController < JsonController

  attr_accessor :profile, :rapd_transaction
  
  def viewDidLoad
    self.navigationController.navigationBar.hidden = true
    self.title = "Recibo"
    super
    
    self.load_back_button
    self.load_title
    self.load_right_button(icon: "more-options-icon", action: "show_refund", custom_bar: true)
    
    if rapd_transaction.amount > 0
      show_refund
    end
  end
  
  def table_data
    [
      {rows: [
        {cell_type: "receipt_header", name: profile.full_name, username: "@#{profile.username}", avatar: profile.photo_url, cpf: "CPF:"},
        {cell_type: "receipt_value", value: rapd_transaction.wallet.wallet_type.currency.short_name, amount: rapd_transaction.amount},
        {cell_type: "receipt_data", title: "Data:", value: rapd_transaction.created_at.format_as("dd/MM/yyyy, HH:mm")},
        {cell_type: "receipt_data", title: "Tipo:", value: rapd_transaction.amount > 0 ? "Recebimento" : "Pagamento", has_disclosure: true},
        {cell_type: "receipt_data", title: "Autorização:", value: rapd_transaction.remote_id.to_s}
      ]}
    ]
  end
  
  def show_refund
    @actionSheet = UIActionSheet.alloc.initWithTitle(nil, delegate:self, cancelButtonTitle:"Cancelar", destructiveButtonTitle:nil, otherButtonTitles: "Estornar valor", nil)
    @actionSheet.showFromToolbar(self.view)
  end

  def actionSheet(actionSheet, clickedButtonAtIndex: buttonIndex)
    
    if buttonIndex == 0
      a = ReverseReceiptionController.new
      a.transaction = self.rapd_transaction
      self.navigationController.pushViewController(a, animated: true)
    end
  end

  def heart_click
    p "heart button clicked"
  end
  
  def message_click
    p "message button clicked"
  end
  

end