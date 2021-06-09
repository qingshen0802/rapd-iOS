class SettingsNotificationsController < JsonController

  def viewDidLoad
    self.title = "Notificações"
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
        {cell_type: "switch", title: "PUSH", isOn: profile.push_notifications_active, disabled: true, action: "togglePush"}
      ]}
    ]
  end

  def togglePush
    self.profile.push_notifications_active = !self.profile.push_notifications_active
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