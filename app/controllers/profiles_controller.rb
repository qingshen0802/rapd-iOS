class ProfilesController < JsonController

  attr_accessor :profiles, :profile_controller, :wallet_controller, :notifications_controller
  
  def viewDidLoad
    self.title = "Profiles"
    
    super
  end
  
  def noContentLabelColor
    UIColor.whiteColor
  end
  
  def load_profiles
    profile_manager = ProfileManager.new
    profile_manager.prefix = "/"
    profile_manager.prepare_mapping(profile_manager.prefix)
    profile_manager.delegate = self
    profile_manager.fetch_all
  end
  
  def items_fetched(profiles)
    self.profiles = profiles
    self.data_table_view.reloadData
  end
  
  def profile_rows
    profiles.map{|profile|
      profile_photo = profile.photo_url if !profile.nil? && !profile.photo_url.nil?
      profile_photo = "https://graph.facebook.com/#{current_user.facebook_id}/picture?width=9999" if profile_photo.to_s =~ /missing.png/ || (!current_user.facebook_id.nil? && profile_photo.to_s.length == 0)

      {cell_type: "profile", name: profile.full_name, username: profile.username, photo: profile_photo, id: profile.remote_id, profile_type: profile.profile_type, action: "select_profile", action_param: profile.remote_id}
    }
  end
  
  def table_data
    if self.profiles.nil?
      []
    else
      [
        {rows: profile_rows}, 
        {rows: [{cell_type: "simple", background_color: :clear, label: "Criar novo perfil", action: "new_profile", color: "ffffff"}]}
      ]
    end
  end
  
  def select_profile(profile_id)
    self.app_delegate.set_current_profile_id(profile_id)
    self.profile_controller.load_profile
    self.wallet_controller.load_profile
    self.notifications_controller.load_notifications
    self.menuContainerViewController.toggleRightSideMenuCompletion(lambda{})
  end
  
  def new_profile
    signup_controller = SignupStoreController.new
    signup_controller.profile_controller = profile_controller
    signup_controller.profiles_controller = self
    self.screen_manager.present_modal(signup_controller, self)
  end
  
  def logout
    self.app_delegate.logout
  end

end