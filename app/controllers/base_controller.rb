class BaseController < UIViewController

  attr_accessor :container_view, :window_title, :navBar
  
  def viewDidLoad
    super
    app_delegate.clear_badge
    store_location
  end
  
  def app_delegate
    UIApplication.sharedApplication.delegate
  end  
  
  def screen_manager
    app_delegate.screen_manager
  end

  def init
    super
    self.tabBarItem.image = UIImage.imageNamed("images/tab_#{self.class.to_s.underscore.gsub('_controller', '')}.png")
    self
  end
    
  def load_back_button
    button = UIButton.new
    self.view.addSubview(button)
    button.place_auto_layout(top: 30, leading: 10, width: 35, height: 35)
    button.setImage(UIImage.imageNamed("images/back-button.png"), forState: UIControlStateNormal)
    button.addTarget(self, action: NSSelectorFromString("back"), forControlEvents: UIControlEventTouchUpInside)
    button
  end
  
  def load_title
    label = UILabel.new
    self.view.addSubview(label)
    label.place_auto_layout(top: 35, center_x: 0, width: 300, height: 25)
    label.font = Fonts.font_named("Roboto-Medium", 18)
    label.text = self.window_title || self.title
    label.textAlignment = NSTextAlignmentCenter
    label.textColor = Theme.secondary_color
    label
  end

  def loadtitle(titletext)
    label = UILabel.new
    self.view.addSubview(label)
    label.place_auto_layout(top: 30, width: 270, height: 45, leading: 20)
    label.font = Fonts.font_named("Roboto-Black", 30)
    label.text = titletext
    label.textAlignment = NSTextAlignmentLeft
    label.textColor = UIColor.blackColor
    label
  end
  
  def load_title_button(title=self.title)
    label = UILabel.new
    self.view.addSubview(label)
    label.place_auto_layout(top: 30, width: 270, height: 45, leading: 20)
    label.font = Fonts.font_named("Roboto-Black", 30)
    label.text = title
    label.textColor = UIColor.blackColor
    
    title_button = UIBarButtonItem.alloc.initWithCustomView(label)
    
    self.navigationItem.leftBarButtonItem = title_button
    self.navigationItem.titleView = UIView.new
  end
  
  def load_right_button(options={})
    button = UIButton.new
    button.setTitle(options[:title], forState: UIControlStateNormal)
    button.setTitleColor(Theme.main_color, forState: UIControlStateNormal)
    button.titleLabel.font = Fonts.font_named("Roboto-Medium", 18)
    button.addTarget(self, action: NSSelectorFromString(options[:action]), forControlEvents: UIControlEventTouchUpInside)    
    button.frame = CGRectMake(0, 0, 65, 30)
    
    if options[:icon]
      button.setImage(UIImage.imageNamed(options[:icon]), forState: UIControlStateNormal)
    end
     
    right_button = UIBarButtonItem.alloc.initWithCustomView(button)
    
    if options[:custom_bar]
      self.view.addSubview(button)
      button.place_auto_layout(top: 20, trailing: 0, width: 35, height: 35)
    else
      self.navigationItem.rightBarButtonItem = right_button
    end
  end
  
  def back
    self.navigationController.popViewControllerAnimated(true)
  end

  def listen_to_keyboard
    NSNotificationCenter.defaultCenter.addObserver(self, 
        selector: NSSelectorFromString("keyboard_appeared:"), 
        name: UIKeyboardWillShowNotification, 
        object: nil)

    NSNotificationCenter.defaultCenter.addObserver(self, 
        selector: NSSelectorFromString("keyboard_disappeared:"), 
        name: UIKeyboardWillHideNotification, 
        object: nil)    
  end

  def setup_right_nav_button(title, action)
    button = UIButton.new
    button.setTitle(title, forState: UIControlStateNormal)
    button.setTitleColor(Theme.main_color, forState: UIControlStateNormal)
    button.titleLabel.font = Fonts.font_named("Roboto-Bold", 18)
    button.addTarget(self, action: NSSelectorFromString(action), forControlEvents: UIControlEventTouchUpInside)    
    button.frame = CGRectMake(0, 0, 65, 30)    
    
    self.navigationItem.rightBarButtonItem = UIBarButtonItem.alloc.initWithCustomView(button)
  end

  def disable_right_nav_button
    self.navigationItem.rightBarButtonItem.enabled = false unless self.navigationItem.rightBarButtonItem.blank?
  end

  def enable_right_nav_button
    self.navigationItem.rightBarButtonItem.enabled = true unless self.navigationItem.rightBarButtonItem.blank?
  end

  def show_loading(message = "Carregando...")
    Dispatch::Queue.main.async do
      SVProgressHUD.showInfoWithStatus(message, maskType: SVProgressHUDMaskTypeBlack)
    end
  end

  def dismiss_loading
    Dispatch::Queue.main.async do  
      SVProgressHUD.dismiss
    end
  end

  def resource_creation_failed
  end

  def resource_update_failed
  end

  def play_sound(sound)
    local_file = NSURL.fileURLWithPath(File.join(NSBundle.mainBundle.resourcePath, sound))
    BW::Media.play(local_file) do |media_player|
      media_player.view.frame = [[0, 0], [0, 0]]
      self.view.addSubview(media_player.view)
      @media_player = media_player
    end
    @media_player.view.removeFromSuperview
  end

  
  def current_user
    app_delegate.current_user
  end

  def store_location
    BW::Location.get_significant(purpose: '') do |result|
      if current_user.present?
        user = current_user
        user.lat = result[:to].coordinate.latitude
        user.lng = result[:to].coordinate.longitude
        user_manager = UserManager.shared_manager
        user_manager.delegate = nil
        user_manager.update_resource(user)
        store_user_locally(user)
      end
    end
  end

  def store_user_locally(user)
    user_data = {
      remote_id: user.remote_id.to_s, 
      email: user.email.to_s, 
      access_token: user.access_token.to_s, 
      lat: user.lat.to_f,
      lng: user.lng.to_f,
      phone_number: user.phone_number.to_s,
      sms_confirmed_at: user.sms_confirmed_at.to_s,
      facebook_id: user.facebook_id.to_s,
      facebook_token: user.facebook_token.to_s
    }

    app_delegate.set_user(user_data)
  end
  
  def store_profile_locally(profile)
    app_delegate.add_local_profile(profile.remote_id)
  end
  
  def hide_tabbar
    self.navigationController.tabBarController.tabBar.hidden = true
  end

  def show_tabbar
    self.navigationController.tabBarController.tabBar.hidden = false
  end  
  
  def title_for_date(date)
    if date == Time.now.strftime("%Y-%m-%d")
      "Hoje"
    elsif date == 1.day.ago.strftime("%Y-%m-%d")
      "Ontem"
    else
      date.format_as("dd/MM/yyyy", "yyyy-MM-dd")
    end
  end  
  
  def store_user_device
    device_token = NSUserDefaults.standardUserDefaults.objectForKey("deviceToken")
    
    if device_token.present?
      device = UserDevice.new(device_token: device_token, device_type: "ios")
      device_manager = UserDeviceManager.shared_manager
      device_manager.delegate = self
      device_manager.create_resource(device)
    else
      user_device_created # We should really tell them it failed
    end
  end
  
  def register_cells(cell_identifiers)
    cell_identifiers.each do |cell_identifier|
      self.data_table_view.registerClass(cell_identifier.camelize.constantize, forCellReuseIdentifier: cell_identifier)
    end
  end

  def show_receipt(rapd_transaction, profile)
    if rapd_transaction.amount >= 0
      if rapd_transaction.from_profile.profile_type == "Company"
        c = ReceiptCompanyController.new
        c.profile = rapd_transaction.from_profile
      else
        c = ReceiptController.new
        c.profile = rapd_transaction.from_profile
      end      
    else
      if rapd_transaction.to_profile.profile_type == "Company"
        c = ReceiptCompanyController.new
        c.profile = rapd_transaction.to_profile
      else
        c = ReceiptController.new
        c.profile = rapd_transaction.to_profile
      end 
    end
    
    c.rapd_transaction = rapd_transaction    
    self.navigationController.pushViewController(c, animated: true)
  end
  
  def load_current_profile
    self.show_loading("Carregando...")
    
    profile_manager = ProfileManager.new
    profile_manager.prefix = "/"
    profile_manager.prepare_mapping(profile_manager.prefix)
    profile_manager.delegate = self
    profile_manager.fetch(app_delegate.current_profile_id)    
  end
  
end