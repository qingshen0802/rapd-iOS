class ReceiptDataCell < BaseCell
  
  def set_data(data = {})
    super(data)
    self.outlets["title_label"].text = data[:title]
    self.outlets["value_label"].text = data[:value] 
  end  
  
end