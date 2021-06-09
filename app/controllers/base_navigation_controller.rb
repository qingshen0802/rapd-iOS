class BaseNavigationController < UINavigationController

  def self.with_controller(controller)
    navigation_controller = UINavigationController.alloc.initWithRootViewController(controller)
    navigation_controller.navigationBar.barTintColor = UIColor.whiteColor
    navigation_controller.navigationBar.translucent = false    
    navigation_controller.navigationBar.tintColor = UIColor.whiteColor
    navigation_controller.navigationBar.setTitleTextAttributes({NSForegroundColorAttributeName => UIColor.whiteColor})
    navigation_controller.navigationBar.setBarStyle(UIStatusBarStyleLightContent)
    navigation_controller
  end

end