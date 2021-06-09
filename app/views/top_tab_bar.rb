class TopTabBar < UIView
  
  attr_accessor :delegate, :current_tab, :facebook_tab, :twitter_tab, :phone_tab, :link_tab
    
  def load_subviews
    self.facebook_tab  = create_tab('facebook')
    self.twitter_tab   = create_tab('twitter')
    self.phone_tab     = create_tab('phone')
    self.link_tab      = create_tab('link')

    tabs.map(&:reset_auto_layout)
    
    self.facebook_tab.place_auto_layout(center_y: 0, leading: 0, height: 90)

    self.twitter_tab.equal_width(self.facebook_tab)
    self.twitter_tab.equal_height(self.facebook_tab)
    self.twitter_tab.center_y(self.facebook_tab)
    self.twitter_tab.horizontal_spaced_to(self.facebook_tab)
    
    self.phone_tab.equal_width(self.facebook_tab)
    self.phone_tab.equal_height(self.facebook_tab)
    self.phone_tab.center_y(self.facebook_tab)
    self.phone_tab.horizontal_spaced_to(self.twitter_tab)
    
    self.link_tab.equal_width(self.facebook_tab)
    self.link_tab.equal_height(self.facebook_tab)
    self.link_tab.center_y(self.facebook_tab)
    self.link_tab.horizontal_spaced_to(self.phone_tab)
    
    self.link_tab.place_auto_layout(trailing: 0)
    
    self.facebook_tab.load_subviews
    self.twitter_tab.load_subviews
    self.phone_tab.load_subviews
    self.link_tab.load_subviews
    
    switch_facebook(false)
  end
  
  def tabs
    [facebook_tab, twitter_tab, phone_tab, link_tab]
  end
  
  def create_tab(icon_name)
    tab_control = TopTabBarTab.new
    tab_control.icon_name = icon_name
    self.addSubview(tab_control)
    tab_control.addTarget(self, action: NSSelectorFromString("switch_#{icon_name}"), forControlEvents: UIControlEventTouchUpInside)
  end
  
  def switch_facebook(call_delegate = true)
    tabs.map(&:make_inactive)
    self.facebook_tab.make_active
    delegate.showFacebookTab if call_delegate
  end
  
  def switch_twitter(call_delegate = true)
    tabs.map(&:make_inactive)
    self.twitter_tab.make_active    
    delegate.showTwitterTab if call_delegate
  end
  
  def switch_phone(call_delegate = true)
    tabs.map(&:make_inactive)
    self.phone_tab.make_active
    delegate.showPhoneTab if call_delegate
  end
  
  def switch_link(call_delegate = true)
    tabs.map(&:make_inactive)
    self.link_tab.make_active
    delegate.showLinkTab if call_delegate
  end
  
end