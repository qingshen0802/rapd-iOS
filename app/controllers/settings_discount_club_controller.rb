class SettingsDiscountClubController < JsonController

  def viewDidLoad
    self.title = "Clube de Desconto"
    super
    back_button = self.load_back_button
    title_label = self.load_title
    unless settings[:title_color].nil?
      title_label.textColor = Theme.color(settings[:title_color])
    end
    self.outlets["bonus_field"].text = profile.discount_club_bonus_amount.to_s
    self.outlets["requirement_field"].text = profile.discount_club_bonus_requirement.to_s
    self.outlets["period_select"].text = period_label_for_value(profile.discount_club_bonus_period).to_s
  end
  
  def table_data
    [
      {rows: [
        {cell_type: "switch", title: "Ativar Clube de Desconto", isOn: profile.discount_club_active, disabled: true, action: "toggleDiscountClub"}
      ]}
    ]
  end
  
  def period_options
    {
      "30 dias" => 30,
      "45 dias" => 45,
      "90 dias" => 90,
      "6 meses" => 180,
      "1 ano" => 365,
    }
  end
  
  def period_label_for_value(value)
    period_options.map{|k, v| k if value == v}.compact.first
  end
  
  def picker_view_data
    {"period_select" => [period_options.keys]}
  end  
  
  def pickerView(pickerView, didSelectRow:row, inComponent:component)
    super(pickerView, didSelectRow:row, inComponent:component)
    period_label = picker_view_data["period_select"].first[row]
    self.profile.discount_club_bonus_period = period_options[period_label]
  end

  def toggleDiscountClub
    self.profile.discount_club_active = !self.profile.discount_club_active
    saveProfile
  end

  def profile_manager
    m = ProfileManager.shared_manager
    m.delegate = self
    m
  end
  
  def saveProfile
    profile_manager.update_resource(profile)
  end
  
  def resource_updated(profile)
    self.profile = profile
  end

  def save_discount
    self.profile.discount_club_bonus_amount = self.outlets["bonus_field"].text.to_f
    self.profile.discount_club_bonus_requirement = self.outlets["requirement_field"].text.to_f
    
    self.app_delegate.display_message("Sucesso", "Configurações de Desconto atualizadas com sucesso")
    saveProfile
  end

  def textFieldShouldReturn(textField)
    textField.resignFirstResponder
  end
   
end