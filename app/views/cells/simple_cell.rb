class SimpleCell < BaseCell
  
  def set_data(data = {})
    super(data)
    
    self.backgroundColor = Theme.color(data[:background_color]) if data[:background_color].present?
    self.outlets["label"].textColor = Theme.color(data[:color]) if data[:color].present?
    self.outlets["label"].text = data[:label]
  end

end