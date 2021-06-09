class AppDelegate
  
  attr_accessor :screen_manager, :window, :facebook
  
  GOOGLE_MAP_API_KEY = "AIzaSyAa7dWLJulWulAs8fIkHGh43d3FD6rqjG0"

  def base_url
    # "http://localhost:3000"
    # "http://192.168.1.122:3000"
    "http://ec2-52-67-169-228.sa-east-1.compute.amazonaws.com"
  end

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    load_appearance
    
    RKObjectManager.setSharedManager(RKObjectManager.managerWithBaseURL(NSURL.URLWithString(base_url)))
    SCFacebook.initWithReadPermissions(["email", "public_profile"], publishPermissions: ["publish_actions"])
    FBSDKProfile.enableUpdatesOnAccessTokenChange(true)

    # LIVE:
    # PagarMe.sharedInstance.encryptionKey = "ak_test_laAOy11lPmpvStfi66FSFBcwDxUjzn"
    # DEV:
    PagarMe.singleton.encryptionKey = "ek_test_bexrqguEPDJfOYa1wR51HgOFsFR6QI"

    GMSServices.provideAPIKey(GOOGLE_MAP_API_KEY)
    
    load_apn(application)
    prepare_stripe
    prepare_hockeyapp
    clear_badge
    load_background_listeners

    self.screen_manager = ScreenManager.new
    @window = screen_manager.start
    true
  end
  
  def load_appearance
    UINavigationBar.appearance.setBarTintColor(UIColor.whiteColor)
    UINavigationBar.appearance.setTranslucent(false)
  end
  
  def load_background_listeners
    NSNotificationCenter.defaultCenter.addObserver(self, selector: NSSelectorFromString("back_from_background"), name: UIApplicationDidBecomeActiveNotification, object: nil)
  end

  def back_from_background
     # Implement callbacks
  end
  
  def display_message(title, message)
    UIAlertView.alloc.initWithTitle(title, message: message, delegate: nil, cancelButtonTitle: "OK", otherButtonTitles: nil).show
  end

  def display_error(message)
    display_message("Erro", message)
  end
  
  def api_access_token
    "YOUR_API_TOKEN"
  end

  def show_alert(title, message)
    alert = UIAlertView.alloc.initWithTitle(title, 
                                message: message, 
                                delegate: nil, 
                                cancelButtonTitle: "Close", 
                                otherButtonTitles: nil)
    alert.show
  end
    
  
  # Hockeyapp
  def prepare_hockeyapp
    BITHockeyManagerLauncher.new.start
  end
  
  # Stripe
  def prepare_stripe
    # publishable_key = "STRIPE_KEY_PROD" # Live
    publishable_key = "STRIPE_KEY_DEV" # Test
    Stripe.setDefaultPublishableKey(publishable_key)
  end
  
  
  # User authentication
  def logged_in?
    !current_user.nil?
  end

  def current_user
    user_data ||= NSUserDefaults.standardUserDefaults.objectForKey("current_user")
    return nil if user_data.nil?
    User.new(user_data)
  end

  def set_user(user_data)
    NSUserDefaults.standardUserDefaults.setObject(user_data, forKey: "current_user")
  end
  
  def access_token
    current_user.access_token
  end  
  
  def add_local_profile(profile_id)
    profile_ids = NSUserDefaults.standardUserDefaults.objectForKey("profile_ids")
    profile_ids = [] if profile_ids.nil?
    new_profile_ids = (profile_ids + [profile_id]).uniq
    NSUserDefaults.standardUserDefaults.setObject(new_profile_ids, forKey: "profile_ids")
  end
  
  def logout
    NSUserDefaults.standardUserDefaults.setObject(nil, forKey: "current_user")
    NSUserDefaults.standardUserDefaults.setObject(nil, forKey: "profile_ids")
    NSUserDefaults.standardUserDefaults.setObject(nil, forKey: "current_profile_id")
    screen_manager.start
  end
  
  def set_profile_ids(profile_ids)
    NSUserDefaults.standardUserDefaults.setObject(profile_ids, forKey: "profile_ids")
  end
  
  def profile_ids
    NSUserDefaults.standardUserDefaults.objectForKey("profile_ids")
  end
  
  def has_profile?
    profile_ids.is_a?(Array) && profile_ids.count > 0
  end
  
  def current_profile_id
    NSUserDefaults.standardUserDefaults.objectForKey("current_profile_id") || profile_ids.first
  end
  
  def set_current_profile_id(profile_id)
    NSUserDefaults.standardUserDefaults.setObject(profile_id, forKey: "current_profile_id")
  end
  
  # Push Notifications
  def load_apn(application)
    settings = UIUserNotificationSettings.settingsForTypes(UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound, categories: nil)
    application.registerUserNotificationSettings(settings)
    application.registerForRemoteNotifications
  end
    
  def application(application, didRegisterForRemoteNotificationsWithDeviceToken: token)
    NSUserDefaults.standardUserDefaults.setObject(token, forKey: "deviceToken")
  end

  def application(application, didFailToRegisterForRemoteNotificationsWithError: error)
    puts "Error Registering APN: #{error}"
  end

  def application(application, didReceiveLocalNotification: userInfo)
    NSLog("LOG: %@", userInfo)
  end

  def application(application, didReceiveRemoteNotification: userInfo)
    if userInfo[:chat_room].present?
      self.redirect_to_chat_room_id = userInfo[:chat_room]
    end    
  end
  
  def clear_badge
    UIApplication.sharedApplication.applicationIconBadgeNumber = 0
    UIApplication.sharedApplication.cancelAllLocalNotifications
  end  
  
  def application(application, openURL:url, sourceApplication: sourceApplication, annotation: annotation)
    FBSDKApplicationDelegate.sharedInstance.application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
  end

end