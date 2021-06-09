class BankTransferController < JsonController
  
  attr_accessor :profile, :bank_accounts, :selected_bank_account, :transaction, :image_picker
  
  def viewDidLoad
    self.title = "Transferência Bancária"
    
    super
    self.load_back_button
    self.load_title
    self.outlets["instructions_label"].text = self.outlets["instructions_label"].text.gsub("[amount]", transaction.readable_amount)
    
    self.bank_accounts = []
    load_bank_accounts
  end
  
  def load_bank_accounts
    bank_account_manager = BankAccountManager.shared_manager
    bank_account_manager.delegate = self
    bank_account_manager.fetch_all(system_accounts: true)
  end
  
  def items_fetched(bank_accounts)
    self.bank_accounts = bank_accounts
    self.selected_bank_account = bank_accounts.first
    self.outlets["bank_select"].text = bank_accounts.first.bank_name
    self.outlets["bank_select"].picker_view.reloadData
    refreshBankAccountInfo
  end
  
  def picker_view_data
    {"bank_select" => [bank_accounts.map(&:bank_name)]}
  end

  def pickerView(pickerView, didSelectRow:row, inComponent:component)
    super(pickerView, didSelectRow:row, inComponent:component)
    self.selected_bank_account = self.bank_accounts[row]
    refreshBankAccountInfo
  end
  
  def refreshBankAccountInfo
    self.outlets["bank_name_label"].text = "Banco: #{selected_bank_account.bank_name}"
    self.outlets["account_info_label"].text = bank_account_info
  end
  
  def identifier
    "389"
  end
  
  def translated_bank_type
    case selected_bank_account.account_type
    when 'Conta Corrente'
      'C/C'
    when 'Conta Poupança'
      'C/P'
    end
  end
  
  def bank_account_info
    [
      "Ag: #{selected_bank_account.branch_number}-#{selected_bank_account.branch_digit}    #{translated_bank_type}: #{selected_bank_account.account_number}-#{selected_bank_account.account_digit}",
      "Identificador: #{identifier}",
      "",
      "KCAPT SERVICOS DE PAGAMENTO LTDA",
      "CNPJ: 209.209.298/0001-10"
    ].join("\n")
  end
  
  def selectPhoto
    self.image_picker = UIImagePickerController.new
    self.image_picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary
    self.image_picker.delegate = self
    self.presentViewController(image_picker, animated: true, completion: nil)
  end
  
  def imagePickerController(picker, didFinishPickingMediaWithInfo: imageInfo)
    extension = imageInfo[UIImagePickerControllerReferenceURL].absoluteString.split("=").last
    self.transaction.attachment = imageInfo[UIImagePickerControllerOriginalImage]
    self.transaction.attachment_mime_type = extension == "JPG" ? "image/jpeg" : "image/png"
    self.outlets["document_image"].image = self.transaction.attachment
    self.image_picker.dismissViewControllerAnimated(true, completion: nil)
  end  
  
  def completeTransfer
    self.show_loading("Carregando...")
    transaction_manager = TransactionManager.shared_manager
    transaction_manager.delegate = self
    transaction_manager.update_resource(transaction)
  end
  
  def resource_updated(transaction)
    self.dismiss_loading
    self.app_delegate.display_message("Sucesso", "Seus dados foram enviados com sucesso. Obrigado")
    self.navigationController.popToRootViewControllerAnimated(true)
  end

end