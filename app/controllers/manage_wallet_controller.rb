class ManageWalletController < JsonController
  
  attr_accessor :profile, :prepaid_card_request
  
  def viewDidLoad
    self.navigationController.navigationBar.hidden = true
    self.title = "Operações financeiras"
    self.table_data = load_table_data
    super
    
    back_button = self.load_back_button
    unless settings[:back_button].nil?
      back_button.setImage(UIImage.imageNamed(settings[:back_button]), forState: UIControlStateNormal)
    end
        
    title_label = self.load_title
    unless settings[:title_color].nil?
      title_label.textColor = Theme.color(settings[:title_color])
    end
    
    load_prepaid_card_requests
  end
  
  def load_prepaid_card_requests
    manager = PrepaidCardRequestManager.shared_manager
    manager.delegate = self
    manager.fetch_all(profile_id: profile.remote_id)
  end
  
  def items_fetched(prepaid_card_requests)
    self.prepaid_card_request = prepaid_card_requests.first if prepaid_card_requests.count > 0
  end
  
  def load_table_data
    [
      {rows: [
        {cell_type: "icon_title_subtitle", icon: "images/money_load_icon.png", title: "Carregar carteira", subtitle: "Carregue crédito nas suas moedas", disclosure: true, action: "loadMoney"},
        {cell_type: "icon_title_subtitle", icon: "images/money_withdraw_icon.png", title: "Resgatar", subtitle: "Resgate seu saldo", disclosure: true, action: "withdraw"},
        {cell_type: "icon_title_subtitle", icon: "images/money_conversion_icon.png", title: "Converter", subtitle: "Converta suas moedas", disclosure: true, action: "convert"},
      # {cell_type: "icon_title_subtitle", icon: "images/money_billings_icon.png", title: "Cobranças", subtitle: "Acesse as cobranças realizadas", disclosure: true, action: "transaction_requests"},
        {cell_type: "icon_title_subtitle", icon: "images/money_reports_icon.png", title: "Relatórios", subtitle: "Tenha uma visão geral do seu portfolio", disclosure: true, action: "reports"},
        {cell_type: "icon_title_subtitle", icon: "images/money_cards_icon.png", title: "Cartões de crédito", subtitle: "Agilize seus pagamentos", disclosure: true, action: "cards"},
      #  {cell_type: "icon_title_subtitle", icon: "images/money_debit_card_icon.png", title: "Cartão de Débito", subtitle: "Peça já o seu", disclosure: true, action: "debitCard"},
      ]}
    ]
  end
  
  def loadMoney
    load_money_controller = LoadMoneyController.new
    load_money_controller.profile = profile
    self.navigationController.pushViewController(load_money_controller, animated: true)
  end
  
  def withdraw
    withdraw_controller = WithdrawController.new
    withdraw_controller.profile = profile
    self.navigationController.pushViewController(withdraw_controller, animated: true)
  end  
  
  def cards
    controller = CreditCardsController.new
    controller.profile = profile
    self.navigationController.pushViewController(controller, animated: true)
  end
  
 # def transaction_requests
 #   controller = TransactionRequestsController.new
 #   controller.profile = profile
 #   self.navigationController.pushViewController(controller, animated: true)
 # end
  
  def reports
    controller = ReportsController.new
    controller.profile = profile
    self.navigationController.pushViewController(controller, animated: true)    
  end
  
  def convert
    controller = ConvertController.new
    controller.profile = profile
    self.navigationController.pushViewController(controller, animated: true)        
  end
  
 # def debitCard
 #   if self.prepaid_card_request.present?
 #     if prepaid_card_request.status != 'unlocked'
 #       display_unlock_card_controller
 #     else
 #       display_card_management_controller
 #     end
 #   else
 #     display_new_card_controller
 #   end
 # end
  
 # def display_new_card_controller
 #   controller = PrepaidCardController.new
 #   controller.profile = profile
 #   self.navigationController.pushViewController(controller, animated: true)    
 # end
  
 # def display_unlock_card_controller
 #   controller = UnlockPrepaidCardController.new
 #   controller.profile = profile
 #   controller.prepaid_card_request = self.prepaid_card_request
 #   self.navigationController.pushViewController(controller, animated: true)
 # end
  
 # def display_card_management_controller
 #   controller = ManagePrepaidCardController.new
 #   controller.profile = profile
 #   controller.prepaid_card_request = self.prepaid_card_request
 #   self.navigationController.pushViewController(controller, animated: true)
 # end
  
end