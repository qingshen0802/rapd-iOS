class WithdrawalDestinationController < JsonController 
  
  attr_accessor :profile, :wallet, :withdrawal_request
  
  def viewDidLoad
    self.title = "Destino do Resgate"
    super

    back_button = self.load_back_button
    unless settings[:back_button].nil?
      back_button.setImage(UIImage.imageNamed(settings[:back_button]), forState: UIControlStateNormal)
    end
        
    title_label = self.load_title
    unless settings[:title_color].nil?
      title_label.textColor = Theme.color(settings[:title_color])
    end
  end  
  
  def table_data
    [{rows: [
      {cell_type: "icon_title_subtitle", icon: "images/withdrawal_destination_bank.png", title: "Transferência Bancária", subtitle: "Disponível em até 3 dias", disclosure: true, action: "selectBankAccount", background_color: "384b58", font_color: "ffffff"},
      {cell_type: "icon_title_subtitle", icon: "images/withdrawal_destination_card.png", title: "Cartão de Débito", subtitle: "Disponível em até 1 dia", disclosure: true, action: "selectCard", background_color: "384b58", font_color: "ffffff"}
    ]}]
  end

  def selectCard
    self.withdrawal_request.request_type = "debit_card"
    update_withdrawal_request
  end
  
  def selectBankAccount
    self.withdrawal_request.request_type = "bank_transfer"
    update_withdrawal_request
  end
  
  def update_withdrawal_request
    withdrawal_request_manager = WithdrawalRequestManager.shared_manager
    withdrawal_request_manager.delegate = self
    withdrawal_request_manager.update_resource(withdrawal_request)
  end
  
  def resource_updated(withdrawal_request)
    self.withdrawal_request = withdrawal_request
    display_confirmation
  end
  
  def display_confirmation
    c = WithdrawalConfirmationController.new
    c.withdrawal_request = withdrawal_request
    c.profile = self.profile
    self.navigationController.pushViewController(c, animated: true)    
  end

end