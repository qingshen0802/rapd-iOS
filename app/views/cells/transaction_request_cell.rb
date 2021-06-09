class TransactionRequestCell < BaseCell
  
  def set_data(data = {})
    super(data)
    self.outlets["avatar"].sd_setImageWithURL(NSURL.URLWithString(data[:photo]), placeholderImage: UIImage.imageNamed("images/profile_placeholder.png"))
    self.outlets["name_label"].text = "@#{data[:name]}"
    self.outlets["status_icon"].image = UIImage.imageNamed("images/status_#{data[:status]}.png")
    self.outlets["status_label"].text = translated_status(data[:status])
    self.outlets["status_label"].textColor = Theme.color(color_for_status(data[:status]))
    self.outlets["amount_label"].text = data[:amount]
    self.outlets["amount_label"].textColor = Theme.color(color_for_status(data[:status]))
  end
  
  def color_for_status(status)
    case status
    when 'cancelled'
      "d9242b"
    when 'processed'
      "48bf81"
    when 'pending'
      "f7b33e"
    end
  end
  
  def translated_status(status)
    case status
    when 'cancelled'
      "Cancelado"
    when 'processed'
      "Pago"
    when 'pending'
      "Aguardando"
    end
  end
  
end