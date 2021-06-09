class UIView

  attr_accessor :settings, :outlets, :outlet_data
    
  include ComponentLoader
  
  def container_view
    self
  end
  
  def build_child_elements(settings)
    self.settings = settings
    loadComponents
  end
  
  def set_leading(leading)
    self.superview.constraints.each do |c|
      if c.firstItem == self
        if c.firstAttribute == NSLayoutAttributeLeading
          c.constant = leading
        end
      end
    end
  end
  
end