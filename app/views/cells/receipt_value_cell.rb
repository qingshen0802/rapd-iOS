class ReceiptValueCell < BaseCell
  
  def set_data(data = {})
    super(data)
    if data[:value] == "R$"
      self.outlets["value_label"].text = "#{data[:value]}#{('%.2f' % data[:amount].abs).to_s.sub(".", ",")}"
    else
      self.outlets["value_label"].text = "#{data[:value]}#{('%.2f' % data[:amount].abs).to_s}"
    end    
  end  
  
end