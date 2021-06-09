class PhoneContactCell < BaseCell
  
  def set_data(data = {})
    super(data)
    self.outlets["name_label"].text = data[:name]
    
    puts "CELL: #{data}"
    case data[:status]
    when 'invited'
      puts "OK CELL"
      self.outlets["invitation_status_label"].hidden = false
      self.outlets["invitation_status_label"].text = "Convidado"
      self.outlets["invitation_status_label"].backgroundColor = Theme.color("cccccc")
    when 'accepted'
      self.outlets["invitation_status_label"].hidden = false
      self.outlets["invitation_status_label"].text = "Cadastrado"
      self.outlets["invitation_status_label"].backgroundColor = Theme.main_color
    else
      self.outlets["invitation_status_label"].hidden = true
    end
  end
  
end