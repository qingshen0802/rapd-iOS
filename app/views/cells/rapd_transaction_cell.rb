class RapdTransactionCell < BaseCell
  
  attr_accessor :report, :wallet, :rapd_transaction
  
  def set_data(data = {})
    super(data)    
    self.report = data[:report]
    self.wallet = data[:wallet]
    self.rapd_transaction = data[:rapd_transaction]

    self.outlets["avatar"].sd_setImageWithURL(NSURL.URLWithString(data[:photo]), placeholderImage: UIImage.imageNamed("images/profile_placeholder.png"))
    self.outlets["name_label"].text = "@#{data[:name]}"
    self.outlets["timestamp_label"].text = rapd_transaction.human_timestamp
    
    if data[:amount].to_f >= 0
      self.outlets["amount_label"].text = "#{wallet.wallet_type.currency.short_name}#{rapd_transaction.human_amount}"
    else
      if wallet.wallet_type.currency.short_name == "R$"
        self.outlets["amount_label"].text = "- #{wallet.wallet_type.currency.short_name}#{('%.2f' % rapd_transaction.amount.abs).to_s.sub(".", ",")}"
      else
        self.outlets["amount_label"].text = "- #{wallet.wallet_type.currency.short_name}#{ ('%.2f' % rapd_transaction.amount.abs).to_s}"
      end
    end
    self.outlets["amount_label"].textColor = Theme.color(color_for_amount(data[:amount]))
  end
  
  def color_for_amount(amount)
    if amount.to_f < 0
      "d9242b"
    else
      "48bf81"
    end
  end
  
end