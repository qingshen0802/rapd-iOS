class ManagePrepaidCardController < JsonController

  attr_accessor :prepaid_card_request, :wallet
  
  def viewDidLoad
    self.title = "Cartão Tratto"
    super
    self.load_back_button
    self.load_title
    
    load_wallet
  end
  
  def load_wallet
    wallet_manager = WalletManager.shared_manager
    wallet_manager.delegate = self
    wallet_manager.fetch_all(profile_id: profile.remote_id, default: true)
  end
  
  def items_fetched(wallets)
    self.wallet = wallets.first
  end
  
  def table_data
    [
      {title: "Opções do Cartão", 
        rows: [
        {cell_type: "simple", label: "Ver extrato do cartão", disclosure: true, action: "cardReport"},
        {cell_type: "simple", label: "Bloquear cartão", disclosure: true, action: "lockCard"},
        {cell_type: "simple", label: "Solicitar novo cartão", disclosure: true, action: "requestNewCard"}
      ]}
    ]
  end

  def manager
    m = PrepaidCardRequestManager.shared_manager
    m.delegate = self
    m
  end
  
  def cardReport
    report_controller = YearlyReportController.new
    report_controller.profile = profile
    report_controller.wallet = wallet
    self.navigationController.pushViewController(report_controller, animated: true)
  end
  
  def lockCard
    prepaid_card_request.lock_request = 'true'
    manager.update_resource(prepaid_card_request)
  end
  
  def requestNewCard
    prepaid_card_request.new_request = 'true'
    manager.update_resource(prepaid_card_request)    
  end
  
  def resource_updated(resource)
    if resource.status == 'locked'
      self.app_delegate.display_message("Sucesso!", "Seu cartão foi bloqueado com sucesso")
    elsif resource.status == 'new_request'
      self.app_delegate.display_message("Sucesso!", "Seu novo cartão foi solicitado com sucesso")
    end

    self.navigationController.popToRootViewControllerAnimated(true)
  end

end