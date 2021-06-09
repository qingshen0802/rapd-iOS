class SettingsSecurityController < JsonController

  def viewDidLoad
    self.title = "Segurança"
    super
    back_button = self.load_back_button
    title_label = self.load_title

    unless settings[:title_color].nil?
      title_label.textColor = Theme.color(settings[:title_color])
    end
  end
  
  def table_data
    [
      {rows: [
        {cell_type: "switch", title: "Ativar TouchID", isOn: profile.touch_id_active, disabled: true, action: "toggleTouchId"}
      ]}
    ]
  end
  
  def toggleTouchId
    self.profile.touch_id_active = !self.profile.touch_id_active
    saveProfile
  end
  
  def saveProfile
    profile_manager = ProfileManager.shared_manager
    profile_manager.delegate = self
    profile_manager.update_resource(profile)    
  end
  
  def resource_updated(profile)
    self.profile = profile
  end  
  
end