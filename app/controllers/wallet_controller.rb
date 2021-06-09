class WalletController < JsonController

  attr_accessor :profile, :wallet, :rapd_transactions, :report, :filter_type, :period_type
  
  def viewDidLoad
    self.rapd_transactions = []
    self.filter_type  = "all"
    self.title = "Dashboard"
    self.period_type  = 'this_year'
    
    super
    
    load_title_button
    load_profile
    
    # Order:
    # 1. Load Profile
    # 2. Load Wallets
    # 3. Load Report
    # 4. Load Transactions
  end

  def viewWillAppear animated
    self.navigationController.navigationBar.hidden = true
    loadMainTitle      
  end
    
  def viewDidAppear(animated)
    super(animated)
    load_report if wallet.present?
  end

  def loadMainTitle
    label = UILabel.new
    self.view.addSubview(label)
    label.place_auto_layout(top: 30, width: 270, height: 45, leading: 20)
    label.font = Fonts.font_named("Roboto-Black", 30)
    label.text = self.title
    label.textAlignment = NSTextAlignmentLeft
    label.textColor = UIColor.blackColor

    button = UIButton.new
    button.setTitle("Portfolio", forState: UIControlStateNormal)
    self.view.addSubview(button) 
    button.setTitleColor(Theme.main_color, forState: UIControlStateNormal)
    button.titleLabel.font = Fonts.font_named("Roboto-Medium", 18)
    button.place_auto_layout(top: 35, trailing: -20, width: 85, height: 35)
    button.addTarget(self, action: NSSelectorFromString("toggle_wallet"), forControlEvents: UIControlEventTouchUpInside)  
  end
  
  def add
    puts "ADD"
  end
  
  def toggle_wallet
    wallets_controller = WalletsController.new
    wallets_controller.delegate = self
    wallets_controller.profile = self.profile
    self.presentModalViewController(wallets_controller, animated: true)
  end
  
  def select_wallet(wallet)
    self.wallet = wallet
    load_report
  end
  
  def no_data_label
    "Não há transações disponíveis"
  end
  
  def noContentLabelColor
    Theme.main_color
  end  
  
  def load_profile
    self.show_loading("Carregando...")    
    profile_manager = ProfileManager.new
    profile_manager.prefix = "/"
    profile_manager.prepare_mapping(profile_manager.prefix)
    profile_manager.delegate = self
    profile_manager.fetch(app_delegate.current_profile_id)    
  end
  
  def item_fetched(element)
    if element.is_a?(Profile)
      self.profile = element
      load_wallets      
    else
      self.report = element
      load_rapd_transactions
    end
  end
  
  def items_fetched(elements)
    if elements.first.is_a?(Wallet)
      elements.each do |wallet_item|
        if wallet_item.is_default == true
          self.wallet = wallet_item
        end
      end
      load_report
    else
      self.rapd_transactions = elements.sort_by(&:created_at).reverse
      self.data_table_view.reloadData
      self.dismiss_loading
    end
  end  
  
  def load_report
    report_manager = YearlyReportManager.shared_manager
    report_manager.delegate = self
    report_manager.fetch(wallet.remote_id, year: Time.now.strftime("%Y"))
  end
    
  def load_wallets
    wallet_manager = WalletManager.shared_manager
    wallet_manager.delegate = self
    wallet_manager.fetch_all(profile_id: profile.remote_id)#, withdrawable: true)    
  end
  
  def load_rapd_transactions
    rapd_transactions_manager = RapdTransactionManager.shared_manager
    rapd_transactions_manager.delegate = self
    rapd_transactions_manager.fetch_all(wallet_id: wallet.remote_id, year: Time.now.strftime("%Y"), filter_type: filter_type, period_type: period_type)
  end
  
  def table_data
    if self.report.blank?
      []
    else
      [
        {rows: [
          {cell_type: "main_wallet", disabled: true, wallet: wallet, period_type: period_type},
          {cell_type: "report_chart", disabled: true, report: report, wallet: wallet},
          {cell_type: "report_filters", current_filter_type: filter_type, wallet: wallet},
        ]}
      ] + 
      rapd_transaction_sections
    end
  end

  def rapd_transaction_sections
    hash_keys = []

    data = self.rapd_transactions.inject({}) do |hash, rapd_transaction| 
      hash_key = rapd_transaction.created_at.split("T").first
      hash_keys << hash_key unless hash_keys.include?(hash_key)
      hash[hash_key] ||= []
      hash[hash_key] << rapd_transaction
      hash
    end
    
    data.map do |date, rapd_transactions|
      transaction_rows = rapd_transactions.map do |rapd_transaction|
        if rapd_transaction.amount >= 0
          {cell_type: "rapd_transaction", name: rapd_transaction.from_profile.username, amount: rapd_transaction.amount, photo: rapd_transaction.from_profile.photo_url, wallet: wallet, rapd_transaction: rapd_transaction, action: "view_receipt", action_param: rapd_transaction}
        else 
          {cell_type: "rapd_transaction", name: rapd_transaction.to_profile.username, amount: rapd_transaction.amount, photo: rapd_transaction.to_profile.photo_url, wallet: wallet, rapd_transaction: rapd_transaction, action: "view_receipt", action_param: rapd_transaction}
        end                
      end
      {title: title_for_date(date), rows: transaction_rows}
    end    
  end  
  
  def filter(type)
    self.filter_type = type
    load_rapd_transactions
  end
  
  def filter_period(period_type)
    self.period_type = period_type
    load_rapd_transactions
  end

  def view_receipt(rapd_transaction)
    show_receipt(rapd_transaction, profile)
  end

end