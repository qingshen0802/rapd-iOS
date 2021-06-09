class ReceiptHeaderCell < BaseCell
  
  def set_data(data = {})
    super(data)

    self.outlets["avatar"].sd_setImageWithURL(NSURL.URLWithString(data[:avatar]), placeholderImage: UIImage.imageNamed("images/profile_placeholder.png"))
    self.outlets["name_label"].text = data[:name]
    self.outlets["username_label"].text = data[:username]
    self.outlets["usercpf_label"].text = data[:cpf]
  end  
  
end