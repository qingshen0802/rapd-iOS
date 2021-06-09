class SocialNetworksController < JsonController
  
  attr_accessor :profile

  def viewDidLoad
    self.navigationController.navigationBar.hidden = true
    self.title = "Redes Sociais"
    super
    
    self.load_back_button
    self.load_title
    load_profile
  end
  
  def table_data
    [
      {rows: [
        {cell_type: "switch", title: "Facebook", action: "toggleFacebook", isOn: profile.facebook_active, disabled: true},
        {cell_type: "switch", title: "Twitter", action: "toggleTwitter", isOn: profile.twitter_active, disabled: true},
        {cell_type: "switch", title: "Google Plus", action: "toggleGooglePlus", isOn: profile.google_plus_active, disabled: true},
        {cell_type: "switch", title: "Instagram", action: "toggleInstagram", isOn: profile.instagram_active, disabled: true}
      ]}
    ]
  end
  
  def load_profile
    profile_manager = ProfileManager.shared_manager
    profile_manager.delegate = self
    profile_manager.fetch(app_delegate.current_profile_id)
  end
  
  def item_fetched(profile)
    self.profile = profile
    self.data_table_view.reloadData
  end
  
  def toggleFacebook
    self.profile.facebook_active = !self.profile.facebook_active
    saveProfile
  end
  
  def toggleTwitter
    self.profile.twitter_active = !self.profile.twitter_active
    saveProfile
  end
  
  def toggleGooglePlus
    self.profile.google_plus_active = !self.profile.google_plus_active
    saveProfile
  end
  
  def toggleInstagram
    self.profile.instagram_active = !self.profile.instagram_active
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