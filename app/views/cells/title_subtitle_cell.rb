class TitleSubtitleCell < BaseCell
  
  def set_data(data = {})
    super(data)
    
    self.outlets["title_label"].text = data[:title]
    self.outlets["title_label"].set_leading(data[:leading]) if data[:leading].present?
    
    self.outlets["subtitle_label"].text = data[:subtitle]
  end
  
end