class BrowseFiltersCell < BaseCell
  
  def set_data(data = {})
    super(data)
    
    self.outlets["proximity_button"].setTitleColor(Theme.tertiary_color, forState: UIControlStateNormal)
    self.outlets["discount_club_button"].setTitleColor(Theme.tertiary_color, forState: UIControlStateNormal)
    self.outlets["favorite_button"].setTitleColor(Theme.tertiary_color, forState: UIControlStateNormal)
    self.outlets["proximity_icon"].image = UIImage.imageNamed("images/browse_proximity")
    self.outlets["discount_club_icon"].image = UIImage.imageNamed("images/browse_discount_club")
    self.outlets["favorite_icon"].image = UIImage.imageNamed("images/browse_favorite")
    if self.outlets["#{data[:current_filter_type]}_button"] && self.outlets["#{data[:current_filter_type]}_icon"]
      self.outlets["#{data[:current_filter_type]}_button"].setTitleColor(Theme.main_color, forState: UIControlStateNormal)
      self.outlets["#{data[:current_filter_type]}_icon"].image = UIImage.imageNamed("images/browse_#{data[:current_filter_type]}_selected")
    end 
  end
  
  def filter_proximity
    self.delegate.filter('proximity')
  end
  
  def filter_discount_club
    self.delegate.filter('discount_club')
  end
  
  def filter_favorites
    self.delegate.filter('favorite')
  end
  
end