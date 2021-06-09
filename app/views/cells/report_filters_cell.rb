class ReportFiltersCell < BaseCell
  attr_accessor :wallet
  
  def set_data(data = {})
    super(data)
    self.wallet = data[:wallet]
    self.outlets["all_button"].setTitleColor(Theme.black_color, forState: UIControlStateNormal)
    self.outlets["purchases_button"].setTitleColor(Theme.black_color, forState: UIControlStateNormal)
    self.outlets["revenue_button"].setTitleColor(Theme.black_color, forState: UIControlStateNormal)
    self.outlets["#{data[:current_filter_type]}_button"].setTitleColor(Theme.main_color, forState: UIControlStateNormal)
    self.outlets["wallet_select"].text = wallet.short_name
  end
  
  def filter_all
    self.delegate.filter('all')
  end
  
  def filter_purchases
    self.delegate.filter('purchases')
  end
  
  def filter_revenue
    self.delegate.filter('revenue')
  end
  
end