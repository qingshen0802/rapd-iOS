class UnlockPrepaidCardController < JsonController

  attr_accessor :prepaid_card_request, :profile

  def viewDidLoad
    self.title = "Cartão Tratto"
    super
    self.load_back_button
    self.load_title    
  end
  
  def pin_view
    self.outlets["pin_view"]
  end
  
  def pinEnteringDidFinish(pinView)
    unlock_card
  end
  
  def unlock_card
    if pin_view.value.present? && pin_view.value.length == 4      
      prepaid_card_request.unlock_pin = pin_view.value
      
      manager = PrepaidCardRequestManager.shared_manager
      manager.delegate = self
      manager.update_resource(prepaid_card_request)      
    end    
  end
  
  def resource_updated(prepaid_card_request)
    self.app_delegate.display_message("Sucesso", "Seu cartão foi desbloqueado com sucesso")
    self.navigationController.popToRootViewControllerAnimated(true)
  end

end