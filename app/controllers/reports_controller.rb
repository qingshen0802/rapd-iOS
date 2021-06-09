class ReportsController < JsonController

  attr_accessor :wallets, :profile
  
  def viewDidLoad
    self.title = "Relatórios"
    super
    load_wallets
    back_button = self.load_back_button
    title_label = self.load_title   
    unless settings[:title_color].nil?
      title_label.textColor = Theme.color(settings[:title_color])
    end   
  end
  
  def noContentLabelColor
    UIColor.whiteColor
  end
  
  def load_wallets
    wallet_manager = WalletManager.shared_manager
    wallet_manager.delegate = self
    wallet_manager.fetch_all(profile_id: profile.remote_id)
  end
  
  def items_fetched(wallets)
    self.wallets = wallets
    self.data_table_view.reloadData
  end
  
  def wallet_rows
    wallets.map{|wallet|
      {cell_type: "no_icon_title_subtitle", title: wallet.wallet_type.name, subtitle: "Acessar relatório", id: wallet.remote_id, action: "select_wallet", action_param: wallet, disclosure: true}
    } + [{cell_type: "no_icon_title_subtitle", title: "Histórico de Compras", subtitle: "Extrato de compras", action: "shopping_history", disclosure: true}]
  end
  
  def table_data
    if self.wallets.nil? || self.wallets.to_a.count == 0
      []
    else
      [{rows: wallet_rows}]
    end
  end
  
  def select_wallet(wallet)
    report_controller = YearlyReportController.new
    report_controller.profile = profile
    report_controller.wallet = wallet
    self.navigationController.pushViewController(report_controller, animated: true)
  end
  
  def shopping_history
    report_controller = ShoppingHistoryController.new
    report_controller.profile = profile
    self.navigationController.pushViewController(report_controller, animated: true)
  end

end