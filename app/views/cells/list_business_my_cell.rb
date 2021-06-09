class ListBusinessMyCell < BaseCell
  
  def set_data(data = {})
    super(data)
    company = data[:action_param]
    
    if data[:icon].present?
      self.outlets["icon"].image = UIImage.imageNamed(data[:icon])
    elsif data[:icon_url].present?
      self.outlets["icon"].sd_setImageWithURL(NSURL.URLWithString(data[:icon_url]), placeholderImage: UIImage.imageNamed("images/profile_placeholder.png"))
    end
    if company.discount_club_active == true
      self.outlets["icon1"].image = UIImage.imageNamed("images/Group.png")
    else
      self.outlets["icon1"].image = nil
    end
    self.outlets["title_label"].text = data[:title]
    self.outlets["subtitle_label"].text = data[:subtitle]
    
    if !data[:background_color].nil?
      self.contentView.backgroundColor = Theme.color(data[:background_color])
    end
    
    if !data[:font_color].nil?
      self.outlets["title_label"].textColor = Theme.color(data[:font_color])
      self.outlets["subtitle_label"].textColor = Theme.color(data[:font_color])
    end
  end
  
end 