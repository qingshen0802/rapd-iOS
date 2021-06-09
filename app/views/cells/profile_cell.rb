class ProfileCell < BaseCell
  
  def set_data(data = {})
    super(data)
    
    self.outlets["avatar"].sd_setImageWithURL(NSURL.URLWithString(data[:photo]), placeholderImage: UIImage.imageNamed("images/profile_placeholder.png"))
    self.outlets["name_label"].text = data[:name]
    self.outlets["username_label"].text = "@#{data[:username]}"
    self.outlets["profile_type_label"].text = "Perfil #{translate(data[:profile_type])}"
    
    if data[:inverse]
      self.outlets["name_label"].textColor = UIColor.blackColor
      self.outlets["username_label"].textColor = UIColor.blackColor
      self.outlets["profile_type_label"].textColor = UIColor.blackColor
      self.container_view.backgroundColor = UIColor.clearColor
    else
      self.container_view.backgroundColor = Theme.secondary_color
    end
    
    self.outlets["checkmark"].hidden = !data[:manage_employees]
    self.outlets["checkmark"].image = UIImage.imageNamed("images/checkmark_blue#{data[:is_employee] ? "_on" : "_off"}.png")
  end
  
  def translate(profile_type)
    case profile_type
    when 'Person'
      "Usuário"
    when 'Company'
      "Lojista"
    else
      profile_type
    end
  end
  
end