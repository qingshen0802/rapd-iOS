class WalletCell < BaseCell
  attr_accessor :celldata
  def set_data(data = {})
    super(data)
    self.celldata = data
    self.outlets["background_view"].backgroundColor = Theme.color(data[:color])
    self.outlets["name_label"].text = data[:name]
    self.outlets["balance_label"].text = data[:balance]
    
    if data[:is_default]
      self.outlets["is_default_background"].hidden = false
      self.outlets["is_default_label"].hidden = false
      self.outlets["is_default_label"].textColor = Theme.color(data[:color])      
    else
      self.outlets["is_default_background"].hidden = true
      self.outlets["is_default_label"].hidden = true  
    end

    longPressRecognizer = UILongPressGestureRecognizer.alloc.initWithTarget(self, action:'long_press_gesture:')
    self.addGestureRecognizer(longPressRecognizer)
  end

  def long_press_gesture(recognizer)
    self.celldata[:delegate].update_default_wallet(self.celldata[:action_param])
  end
  
end