class ShoppingHistoryController < JsonController
  
  attr_accessor :profile, :wallet, :month, :yearly_report, :transactions
  
  def viewDidLoad
    self.title = "Histórico de Compras"
    super
    load_transactions
    back_button = self.load_back_button
    title_label = self.load_title 
    unless settings[:title_color].nil?
      title_label.textColor = Theme.color(settings[:title_color])
    end  

  end
  
  def noContentLabelColor
    UIColor.whiteColor
  end
  
  def load_transactions
    self.show_loading("Carregando...")
    transactions_manager = TransactionManager.shared_manager
    transactions_manager.delegate = self
    transactions_manager.fetch_all(profile_id: profile.remote_id)
  end
  
  def items_fetched(transactions)
    self.transactions = transactions
    self.data_table_view.reloadData
    self.dismiss_loading
  end
  
  def table_data
    if self.transactions.nil?
      []
    else
      transactions_sections
    end
  end

  def transactions_sections
    hash_keys = []

    data = self.transactions.inject({}) do |hash, transaction| 
      hash_key = transaction.created_at.split("T").first
      hash_keys << hash_key unless hash_keys.include?(hash_key)
      hash[hash_key] ||= []
      hash[hash_key] << transaction
      hash
    end
    
    data.map do |date, transactions|
      transaction_rows = transactions.map do |transaction|
        {cell_type: "shopping_history", transaction: transaction}
      end
      {title: title_for_date(date), rows: transaction_rows}
    end    
  end    
  
end