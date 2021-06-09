class IconTitleSubtitleCell < BaseCell
  
  def set_data(data = {})
    super(data)
    if data[:icon].present?
      self.outlets["icon"].image = UIImage.imageNamed(data[:icon])
    elsif data[:icon_url].present?
      self.outlets["icon"].sd_setImageWithURL(NSURL.URLWithString(data[:icon_url]), placeholderImage: UIImage.imageNamed("images/profile_placeholder.png"))
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