class WalletsController < JsonController
  
  attr_accessor :profile, :wallets, :delegate
  
  def viewDidLoad
    self.title = "Portfolio"
    super
    
    title_label = self.load_title
    unless settings[:title_color].nil?
      title_label.textColor = Theme.color(settings[:title_color])
    end

    load_wallets if wallets.blank?
  end
  
  def load_wallets
    wallet_manager = WalletManager.shared_manager
    wallet_manager.delegate = self
    wallet_manager.fetch_all(profile_id: profile.remote_id)#, withdrawable: true)
  end
  
  def items_fetched(wallets)
    self.wallets = wallets
    #puts "wallets: #{self.wallets}"
    self.data_table_view.reloadData
  end
  
  def wallet_rows
    return [] if self.wallets.nil?
    
    self.wallets.map do |wallet|
      {cell_type: "wallet", name: wallet.wallet_type.name, balance: "#{wallet.wallet_type.currency.short_name} #{wallet.human_balance}", color: wallet.wallet_type.color, is_default: wallet.is_default, action: "select_wallet", delegate: self, action_param: wallet}
    end
  end
  
  def table_data
    [{rows: wallet_rows}]
  end
  
  def select_wallet(wallet)
    self.delegate.select_wallet(wallet)
    close
  end
  
  def close
    self.dismissViewControllerAnimated(true, completion: nil)
  end

  def update_default_wallet(sel_wallet)
    self.wallets.each do |walletitem|      
      if sel_wallet == walletitem
        walletitem.is_default = true
      else
        walletitem.is_default = false
      end
      wallet_manager = WalletManager.shared_manager
      wallet_manager.delegate = self
      wallet_manager.update_resource(walletitem)
    end
    self.delegate.select_wallet(sel_wallet)
    self.data_table_view.reloadData
  end

  def resource_updated(element)
  end

  def resource_update_failed
    p "error"
  end
end