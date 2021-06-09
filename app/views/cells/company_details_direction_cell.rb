class CompanyDetailsDirectionCell < BaseCell

  
  def set_data(data = {})
    super(data)

    store = data[:store]
    
    self.outlets["title_label"].text = store.address
    self.outlets["distance_label"].text = store.distance

  end

  def view_map 
    self.delegate.view_map()
  end 

end