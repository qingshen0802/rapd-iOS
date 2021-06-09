class MonthlyReportController < JsonController
  
  attr_accessor :profile, :wallet, :month, :yearly_report, :rapd_transactions
  
  def viewDidLoad
    self.title = self.wallet.wallet_type.name
    super
    load_rapd_transactions
    back_button = self.load_back_button
    title_label = self.load_title    
    unless settings[:title_color].nil?
      title_label.textColor = Theme.color(settings[:title_color])
    end
  end
  
  def noContentLabelColor
    UIColor.whiteColor
  end
  
  def load_rapd_transactions
    self.show_loading("Carregando...")
    rapd_transactions_manager = RapdTransactionManager.shared_manager
    rapd_transactions_manager.delegate = self
    rapd_transactions_manager.fetch_all(wallet_id: wallet.remote_id, month: month)
  end
  
  def items_fetched(rapd_transactions)
    self.rapd_transactions = rapd_transactions
    self.data_table_view.reloadData
    self.dismiss_loading
  end
  
  def table_data
    if self.rapd_transactions.nil?
      []
    else
      [
        {rows: [
          {cell_type: "report_data_small", wallet: wallet, transactions_count: rapd_transactions.count.to_s, transactions_balance: rapd_transactions.sum(&:amount).to_s}
          ]
        }
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
        {cell_type: "rapd_transaction", name: rapd_transaction.to_profile.username, amount: rapd_transaction.amount, photo: rapd_transaction.to_profile.photo_url, wallet: wallet, rapd_transaction: rapd_transaction}
      end
      {title: title_for_date(date), rows: transaction_rows}
    end    
  end  
  
end