class BrowseStoreFiltersCell < BaseCell
  
  def set_data(data = {})
    super(data)
    
    self.backgroundColor = Theme.color('f1f2f4')
    self.outlets["all_button"].setTitleColor(Theme.tertiary_color, forState: UIControlStateNormal)
    self.outlets["credit_button"].setTitleColor(Theme.tertiary_color, forState: UIControlStateNormal)
    
    if self.outlets["#{data[:current_store_filter_type]}_button"]
      self.outlets["#{data[:current_store_filter_type]}_button"].setTitleColor(Theme.black_color, forState: UIControlStateNormal)
    end
  end
  
  def filter_all
    self.delegate.store_filter('all')
  end
  
  def filter_credit
    self.delegate.store_filter('credit')
  end
  
  
end