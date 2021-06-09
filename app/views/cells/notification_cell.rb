class NotificationCell < BaseCell
  def set_data(data = {})
    super(data)
    
    notification = data[:notification]

    if notification.title.include? "Você enviou um pagamento"
      #username = notification.to_user_name.present? ? "@#{notification.to_user_name} " : ""
      self.outlets["title_label"].text = "#{notification.description.camelize(:lower)}"
      self.outlets["image"].sd_setImageWithURL(NSURL.URLWithString(notification.to_user_photo_url), placeholderImage: UIImage.imageNamed("images/profile_placeholder.png"))
    elsif notification.title.include? "Você recebeu um pagamento"
      #username = notification.from_user_name.present? ? "@#{notification.from_user_name} " : ""
      self.outlets["title_label"].text = "#{notification.description.camelize(:lower)}"
      self.outlets["image"].sd_setImageWithURL(NSURL.URLWithString(notification.from_user_photo_url), placeholderImage: UIImage.imageNamed("images/profile_placeholder.png"))
    elsif notification.title.include? "Solicitação de Pagamento"
      #username = notification.from_user_name.present? ? "@#{notification.from_user_name} " : ""
      self.outlets["title_label"].text = "#{notification.description.camelize(:lower)}"
      self.outlets["image"].sd_setImageWithURL(NSURL.URLWithString(notification.from_user_photo_url), placeholderImage: UIImage.imageNamed("images/profile_placeholder.png"))
    elsif notification.title.include? "Recebeu sua solicitação de Pagamento"
      #username = notification.to_user_name.present? ? "@#{notification.to_user_name} " : ""
      self.outlets["title_label"].text = "#{notification.description.camelize(:lower)}"
      self.outlets["image"].sd_setImageWithURL(NSURL.URLWithString(notification.to_user_photo_url), placeholderImage: UIImage.imageNamed("images/profile_placeholder.png"))
    else
      #username = notification.from_user_name.present? ? "@#{notification.from_user_name} " : ""
      self.outlets["title_label"].text = "#{notification.description.camelize(:lower)}"
      self.outlets["image"].sd_setImageWithURL(NSURL.URLWithString(notification.from_user_photo_url), placeholderImage: UIImage.imageNamed("images/profile_placeholder.png"))
    end

    self.outlets['subtitle_label'].text = notification.created_at.time_count
    self.outlets["type_color"].backgroundColor = Theme.color(notification.color)
  end
end
