class DocumentStatusCell < BaseCell
  
  def set_data(data = {})
    super(data)
    self.outlets["title_label"].text = data[:title]
    self.outlets["subtitle_label"].text = data[:subtitle]
    self.outlets["status_icon"].image = UIImage.imageNamed(data[:status_icon])
  end
  
end