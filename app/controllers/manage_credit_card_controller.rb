class ManageCreditCardController < JsonController
  
  attr_accessor :credit_card, :credit_cards_controller
  
  def viewDidLoad
    self.title = "Cartão de Crédito"
    super
    back_button = self.load_back_button
    title_label = self.load_title    
  end
  
  def deleteCard
    credit_card_manager = CreditCardManager.shared_manager
    credit_card_manager.delegate = self
    credit_card_manager.delete_resource(credit_card)
  end
  
  def resource_deleted
    self.credit_cards_controller.load_credit_cards
    self.app_delegate.display_message("Sucesso", "Cartão removido com sucesso")
    self.navigationController.popViewControllerAnimated(true)
  end
  
end