class ReportDataSmallCell < BaseCell
  
  attr_accessor :wallet
  
  def set_data(data = {})
    super(data)
    self.wallet = data[:wallet]

    self.outlets["transactions_label"].text = data[:transactions_count]
    self.outlets["balance_label"].text = "#{wallet.wallet_type.currency.short_name} #{data[:transactions_balance]}"
  end
  
end