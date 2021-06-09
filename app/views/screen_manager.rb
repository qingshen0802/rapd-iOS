class ScreenManager

  attr_accessor :window

  def app_delegate
    UIApplication.sharedApplication.delegate
  end

  def start
    if app_delegate.logged_in?
      if app_delegate.current_user.sms_confirmed?
        present_main
      else
        if app_delegate.has_profile?
          present_verify_account
        else
          present_signup
        end
      end
    else
      present_launch
    end
  end

  def load_window(controller, navigation = false)
    self.window ||= UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    if navigation
      navigation_controller = UINavigationController.new
      navigation_controller.viewControllers = [controller]
      self.window.rootViewController = navigation_controller
    else
      self.window.rootViewController = controller
    end
    
    self.window.makeKeyAndVisible
    self.window
  end

  def present_main
    load_window(main_controller)
  end
  
  def main_controller
    profile_controller = ProfileController.new
    
    wallet_controller_instance = wallet_controller
    home_controller_instance = home_controller
    notifications_controller_instance = notifications_controller
    
    profiles_controller = ProfilesController.new
    profiles_controller.profile_controller = profile_controller
    profiles_controller.wallet_controller = wallet_controller_instance
    profiles_controller.notifications_controller = notifications_controller_instance
    notifications_controller.load_notifications
    profiles_controller.load_profiles
    
    profile_controller.profiles_controller = profiles_controller
    
    home_controller_instance.wallet_controller = wallet_controller_instance

    UITabBar.appearance.tintColor = Theme.main_color
    
    tab_bar = BaseTabBarController.with_controllers([
      BaseNavigationController.with_controller(wallet_controller_instance), 
      BaseNavigationController.with_controller(browse_controller),
      BaseNavigationController.with_controller(home_controller_instance),
      BaseNavigationController.with_controller(notifications_controller_instance),
      BaseNavigationController.with_controller(profile_controller)
    ])
    
    tab_bar.tabBar.items[0].title = "Dashboard"
    tab_bar.tabBar.items[1].title = "Rede"
    
    home_image = UIImage.imageNamed("images/home_icon.png").imageWithRenderingMode(UIImageRenderingModeAlwaysOriginal)
    tab_bar.tabBar.items[2].title = ""
    tab_bar.tabBar.items[2].image = home_image
    tab_bar.tabBar.items[2].selectedImage = home_image
    tab_bar.tabBar.items[2].imageInsets = UIEdgeInsetsMake(7, 0, -7, 0)
    
    tab_bar.tabBar.items[3].title = "Atividades"
    tab_bar.tabBar.items[4].title = "Outras"
    
    MFSideMenuContainerViewController menu_container = MFSideMenuContainerViewController.containerWithCenterViewController(tab_bar, leftMenuViewController: nil, rightMenuViewController: profiles_controller)
    menu_container
  end
  
  def present_modal(controller, parent_controller)
    parent_controller.presentViewController(controller, animated: true, completion: nil)
  end

  def present_terms(parent_controller)
    present_modal(terms_controller, parent_controller)
  end

  def present_privacy_policy(parent_controller)
    present_modal(privacy_policy_controller, parent_controller)
  end
  
  def terms_controller 
    # controller = WebController.alloc.init
    # controller.title = "Terms and Conditions"
    # controller.url = "http://www.trat.to"
    controller = TermsController.alloc.init
    BaseNavigationController.with_controller(controller)
  end

  def privacy_policy_controller
    controller = WebController.alloc.init
    controller.title = "Privacy Policy"
    controller.url = "#{app_delegate.base_url}/privacy_policy"
    BaseNavigationController.with_controller(controller)
  end

  def present_signup(options = {})
    load_window(signup_controller(options), true)
  end
  
  def login_controller
    LoginController.new
  end

  def signup_controller(options = {})
    c = SignupController.new
    options.map do |k, v|
      c.send("#{k}=", v) if c.respond_to?("#{k}=")
    end
    c
  end

  def method_missing(method, *args, &block)
    if method =~ /^present/
      load_window(send("#{method.gsub("present_", "")}_controller"), true)
    elsif method =~ /controller/
      method.camelize.constantize.new      
    end
  end
  
end