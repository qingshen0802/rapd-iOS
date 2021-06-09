class TopTabBarTab < UIControl
  
  attr_accessor :icon_name, :icon, :indicator
  
  def make_active
    self.icon.image = UIImage.imageNamed("images/top_tab_#{icon_name}_on.png")
    self.indicator.hidden = false
  end
  
  def make_inactive
    self.icon.image = UIImage.imageNamed("images/top_tab_#{icon_name}_off.png")
    self.indicator.hidden = true
  end
  
  def load_subviews
    self.icon = UIImageView.new
    self.addSubview(icon)
    self.icon.place_auto_layout(center_x: 0, center_y: 0, width: 29, height: 29)

    self.indicator = UIImageView.new
    self.indicator.hidden = true
    self.indicator.image = UIImage.imageNamed("images/top_tab_arrow.png")
    self.addSubview(indicator)
    self.indicator.place_auto_layout(bottom: 0, width: 15, height: 10, center_x: 0)    
  end
  
end