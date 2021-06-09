class UIView

  attr_accessor :attach_to_super_super_view

  def place_expanded_into_view(view)
    self.translatesAutoresizingMaskIntoConstraints = false

    self.center_x(view)
    self.center_y(view)
    self.equal_width(view)
    self.equal_height(view)
  end
  
  def self_constraints
    [:width, :height]
  end
  
  def parent_constraints
    [:leading, :trailing, :top, :bottom, :center_x, :center_y]
  end

  def reset_auto_layout
    self.translatesAutoresizingMaskIntoConstraints = false
  end

  def place_auto_layout(options = {})
    reset_auto_layout
    options.map do |k, v|
      if self_constraints.include?(k.to_sym)
        add_self_constraint(constraint_types[k.to_sym], v)
      elsif parent_constraints.include?(k.to_sym)
        add_parent_constraint(constraint_types[k.to_sym], v)
      end
    end
  end

  def constraint_types
    {
      leading: NSLayoutAttributeLeading,
      trailing: NSLayoutAttributeTrailing,
      top: NSLayoutAttributeTop,
      bottom: NSLayoutAttributeBottom,
      center_x: NSLayoutAttributeCenterX,
      center_y: NSLayoutAttributeCenterY,
      width: NSLayoutAttributeWidth,
      height: NSLayoutAttributeHeight
    }
  end

  def remove_constraints(options = [])
    options.each do |c|
      remove_constraints_of_type(constraint_types[c])
    end
  end

  def remove_parent_constraints(options = [])
    options.each do |c|
      remove_parent_contraints_of_type(constraint_types[c])
    end    
  end

  def remove_parent_contraints_of_type(type)
    removable = []

    self.superview.constraints.each do |c|
      removable << c if c.firstItem == self && c.firstAttribute == type
    end
    self.superview.removeConstraints(removable) if removable.count > 0
  end

  def remove_constraints_of_type(type)
    removable = []

    self.superview.constraints.each do |c|
      removable << c if c.firstItem == self && c.firstAttribute == type
    end
    self.removeConstraints(removable) if removable.count > 0
  end

  def center_x(view)
    self.equal_constraint(:center_x, view)
  end

  def center_y(view)
    self.equal_constraint(:center_y, view)
  end

  def equal_width(view)
    self.equal_constraint(:width, view)
  end

  def equal_height(view)
    self.equal_constraint(:height, view)
  end

  def horizontal_spaced_to(view, constant = 0.0)
    add_parent_foreign_constraint(view, NSLayoutAttributeLeading, NSLayoutAttributeTrailing, constant)
  end
  
  def vertical_spaced_to(view, constant = 0.0)
    add_parent_foreign_constraint(view, NSLayoutAttributeTop, NSLayoutAttributeBottom, constant)
  end  

  def equal_constraint(type, view)
    if view != superview
      add_parent_foreign_constraint(view, constraint_types[type.to_sym], constraint_types[type.to_sym], 0.0)
    else
      add_parent_constraint(constraint_types[type.to_sym], 0.0)      
    end
  end

  def add_parent_constraint(constraint_constant, constant)
    parent_view = attach_to_super_super_view ? self.superview.superview : self.superview
    
    parent_view.addConstraint(
      NSLayoutConstraint.constraintWithItem(self, 
        attribute: constraint_constant, 
        relatedBy: NSLayoutRelationEqual, 
        toItem: parent_view, 
        attribute: constraint_constant, 
        multiplier: 1.0, 
        constant: constant))
  end
  
  def add_parent_foreign_constraint(target_view, constraint_constant, target_constraint_constant, constant)
    self.superview.addConstraint(
      NSLayoutConstraint.constraintWithItem(self, 
        attribute: constraint_constant, 
        relatedBy: NSLayoutRelationEqual, 
        toItem: target_view, 
        attribute: target_constraint_constant, 
        multiplier: 1.0,
        constant: constant))
  end

  def add_self_constraint(constraint_constant, constant)
    self.addConstraint(
      NSLayoutConstraint.constraintWithItem(self, 
        attribute: constraint_constant, 
        relatedBy: NSLayoutRelationEqual, 
        toItem: nil, 
        attribute: 0, 
        multiplier: 1.0, 
        constant: constant))
  end

end