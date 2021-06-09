class CompanyDetailsInfoCell < BaseCell
  
  def set_data(data = {})
    super(data)
    store = data[:store]
    self.outlets["title_label"].text = store.description

  end

end