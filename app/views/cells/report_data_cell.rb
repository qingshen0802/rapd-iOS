class ReportDataCell < BaseCell
  
  attr_accessor :report, :wallet
  
  def set_data(data = {})
    super(data)
    self.report = data[:report]
    self.wallet = data[:wallet]
    
    self.outlets["month_label"].text = data[:month_label]
    self.outlets["transactions_count_label"].text = report.rapd_transactions.count.to_s
    self.outlets["balance_label"].text = "#{wallet.wallet_type.currency.short_name} #{report.current_balance}"
  end
  
end