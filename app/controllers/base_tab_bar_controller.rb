class BaseTabBarController
  
  include TabBarControllerDelegate

  def self.with_controllers(controllers)
    tabBarController = UITabBarController.alloc.init
    tabBarController.viewControllers = controllers
    tabBarController.delegate = self
    tabBarController
  end

end