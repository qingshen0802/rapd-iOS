class CompanyDetailsPromotionsCell < BaseCell
  
  def set_data(data = {})
    super(data)
    store = data[:store]
    # discount 
    self.outlets["discount_label"].text 
  end

end