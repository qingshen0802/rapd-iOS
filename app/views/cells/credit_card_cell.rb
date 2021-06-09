class CreditCardCell < BaseCell
  
  def set_data(data = {})
    super(data)
    self.selectionStyle = UITableViewCellSelectionStyleNone
    self.outlets["gear_button"].removeTarget(nil, action: nil, forControlEvents: UIControlEventAllEvents)
    self.outlets["switch"].removeTarget(nil, action: nil, forControlEvents: UIControlEventAllEvents)

    self.outlets["switch"].addTarget(self.delegate, action: NSSelectorFromString("markCardAsDefault:"), forControlEvents: UIControlEventValueChanged)
    self.outlets["gear_button"].addTarget(self.delegate, action: NSSelectorFromString("manageCreditCard:"), forControlEvents: UIControlEventTouchUpInside)
    
    self.outlets["card_created_label"].text = data[:card_created_text]
    self.outlets["card_number_label"].text = data[:card_number]
    self.outlets["logo_image"].image = UIImage.imageNamed(data[:card_logo])
    
    if data[:card_logo] == 'images/visa_logo.png'
      self.outlets["square"].backgroundColor = Theme.color("134793")
    else
      self.outlets["square"].backgroundColor = Theme.color("363666")
    end
    
    self.outlets["switch"].setOn(data[:is_default_card], animated: false)
  end
  
end