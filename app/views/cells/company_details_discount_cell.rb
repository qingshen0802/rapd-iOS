class CompanyDetailsDiscountCell < BaseCell
  attr_accessor :form_view

  def layoutSubviews    
    super
    load_text_field
  end 
  
  def set_data(data = {})
    super(data)
    store = data[:store]
    self.outlets["amount_label"].text = "R$ " + store.discount_club_bonus_amount.to_s
    self.outlets["expiration_label"].text = "Validade:" + store.discount_club_bonus_period.to_s

    if !store.discount_club_active
      self.outlets["icon1"].hidden = true
      self.outlets["icon"].hidden = true
      self.outlets["discount_label"].hidden = true
      self.outlets["amount_label"].hidden = true
      self.outlets["info_button"].hidden = true
      self.outlets["expiration_label"].hidden = true
      self.outlets["payment_field"].hidden = true

      self.outlets["payment_button"].place_auto_layout(top: 20)
    else
      self.outlets["icon1"].hidden = false
      self.outlets["icon"].hidden = false
      self.outlets["discount_label"].hidden = false
      self.outlets["amount_label"].hidden = false
      self.outlets["info_button"].hidden = false
      self.outlets["expiration_label"].hidden = false
      self.outlets["payment_field"].hidden = false
    end
    # self.outlets["payment_button"]
  end
  
  def make_payment
    amount = self.outlets["payment_field"].text.gsub(/[^0-9]/,'').to_f / 100.00
    self.delegate.make_payment(amount)
  end
  
  def information
    self.delegate.information()
  end

  def load_text_field
    text = self.outlets["payment_field"]
    text.font = Fonts.font_named("Roboto", 16)
    text.delegate = self 
    text.textColor = Theme.secondary_color
    text.textAlignment = UITextAlignmentCenter
    text.keyboardType = UIKeyboardTypeDecimalPad;
    text.backgroundColor = Theme.color("f1f2f4")
  end

  def textViewDidChange
    p "edit start"
  end 

  def textView(textView, shouldChangeTextInRange:range, replacementText:text)
    if text == "\n"
      textView.resignFirstResponder()
      make_payment
      return false 
    end 
    true
  end

  def touchesBegan(touches, withEvent:event)
    text = self.outlets["payment_field"]
    text.delegate = self
    text.resignFirstResponder()
  end

end