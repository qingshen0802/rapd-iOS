class PinView < UIView
  
  attr_accessor :delegate, :text_1, :text_2, :text_3, :text_4, :border_color
  
  def load_subviews
    self.text_1 = create_pin_text_field
    self.text_2 = create_pin_text_field
    self.text_3 = create_pin_text_field
    self.text_4 = create_pin_text_field
    
    fields.map(&:reset_auto_layout)
    
    self.text_1.place_auto_layout(center_y: 0, leading: 0, height: 80)
    
    self.text_2.equal_width(self.text_1)
    self.text_2.equal_height(self.text_1)
    self.text_2.center_y(self.text_1)
    self.text_2.horizontal_spaced_to(self.text_1, 10.0)

    self.text_3.equal_width(self.text_1)
    self.text_3.equal_height(self.text_1)
    self.text_3.center_y(self.text_1)
    self.text_3.horizontal_spaced_to(self.text_2, 10.0)
    
    self.text_4.equal_width(self.text_1)
    self.text_4.equal_height(self.text_1)
    self.text_4.center_y(self.text_1)
    self.text_4.horizontal_spaced_to(self.text_3, 10.0)
    
    self.text_4.place_auto_layout(trailing: 0)
  end
  
  def fields
    [text_1, text_2, text_3, text_4]
  end
  
  def create_pin_text_field
    field = UITextField.new
    field.delegate = self
    field.font = Fonts.normal_font_bold(60.0)
    field.textAlignment = NSTextAlignmentCenter
    field.keyboardType = UIKeyboardTypeNumberPad

    field.addTarget(self, action: NSSelectorFromString("textFieldDidChange:"), forControlEvents: UIControlEventEditingChanged)
    
    field.autoresizingMask    = UIViewAutoresizingFlexibleWidth
    field.layer.borderWidth   = 1.0
    field.layer.borderColor   = UIColor.blackColor.CGColor
    field.clipsToBounds       = true    
    field.layer.cornerRadius  = 8.0

    self.addSubview(field)
    field
  end


  def textFieldDidChange(textField)
    if textField.text.length == 1
      next_field = get_next_field(textField)
      next_field.text = "" if next_field.present?
    elsif textField.text.length == 0
      next_field = get_next_field(textField, false)
    end
    
    if next_field.present?
      next_field.becomeFirstResponder
    else
      textField.resignFirstResponder
      delegate.pinEnteringDidFinish(self)
    end
  end
  
  def textField(textField, shouldChangeCharactersInRange: range, replacementString: string)
    if range.location == 0      
      true
    else
      false
    end
  end
  
  def get_next_field(textField, right_direction = true)
    if right_direction
      case textField
      when text_1
        text_2
      when text_2
        text_3
      when text_3
        text_4
      when text_4
        nil
      end      
    else
      case textField
      when text_4
        text_3
      when text_3
        text_2
      when text_2
        text_1
      when text_1
        nil
      end      
    end
  end
  
  def value
    fields.map(&:text).join("")
  end
  
end