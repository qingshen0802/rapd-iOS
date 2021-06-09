class NoIconTitleSubtitleCell < BaseCell
  
  def set_data(data = {})
    super(data)
    
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