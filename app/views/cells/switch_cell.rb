class SwitchCell < BaseCell
  
  def set_data(data = {})
    super(data)
    self.outlets["label"].text = data[:title]
    self.outlets["switch"].setOn(data[:isOn], animated: false)
    self.outlets["switch"].addTarget(nil, action: nil, forControlEvents:UIControlEventAllEvents)
    self.outlets["switch"].addTarget(self.delegate, action: NSSelectorFromString(data[:action]), forControlEvents:UIControlEventValueChanged)
  end
  
end