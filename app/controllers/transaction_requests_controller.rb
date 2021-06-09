class TransactionRequestsController < JsonController

  attr_accessor :transaction_requests, :profile, :query

  def viewDidLoad
    self.title = "Suas cobranças"
    super
    back_button = self.load_back_button
    title_label = self.load_title
    unless settings[:title_color].nil?
      title_label.textColor = Theme.color(settings[:title_color])
    end
    load_transaction_requests
  end
  
  def performSearch
    load_transaction_requests
  end  
  
  def transaction_requests_sections
    hash_keys = []

    data = self.transaction_requests.inject({}) do |hash, transaction_request| 
      hash_key = transaction_request.created_at.split("T").first
      hash_keys << hash_key unless hash_keys.include?(hash_key)
      hash[hash_key] ||= []
      hash[hash_key] << transaction_request
      hash
    end
    
    data.map do |date, transaction_requests|
      transaction_rows = transaction_requests.map do |transaction_request|
        {cell_type: "transaction_request", name: transaction_request.to_profile.username, status: transaction_request.status, amount: transaction_request.human_amount, photo: transaction_request.to_profile.photo_url}
      end
      {title: title_for_date(date), rows: transaction_rows}
    end    
  end
  
  def table_data
    if self.transaction_requests.nil?
      []
    else
      transaction_requests_sections
    end
  end
  
  def load_transaction_requests
    transaction_request_manager = TransactionRequestManager.shared_manager
    transaction_request_manager.delegate = self
    transaction_request_manager.fetch_all(profile_id: profile.remote_id, query: query)
  end
  
  def items_fetched(transaction_requests)
    self.transaction_requests = transaction_requests
    self.data_table_view.reloadData
  end

end