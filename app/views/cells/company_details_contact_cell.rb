class CompanyDetailsContactCell < BaseCell
  
  def set_data(data = {})
    super(data)
    store = data[:store]
    self.outlets["telephone_label"].text = store.phone_number.to_s
    
  end

  def view_site
    self.delegate.view_site()
  end
  
  def call_store
    self.delegate.call_store()
  end

end