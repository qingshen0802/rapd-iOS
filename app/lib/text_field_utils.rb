class UITextField
  attr_accessor :picker_view
end

class UnderlinedTextField < UITextField
  
  attr_accessor :line_color
  
  def initialize(options = {})
    self.init
    self.line_color = options[:line_color] if options[:line_color].present?
  end
  
  def drawRect(rect)
    startingPoint   = CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect))
    endingPoint     = CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect))
    path = UIBezierPath.new
    
    path.moveToPoint(startingPoint)
    path.addLineToPoint(endingPoint)
    path.lineWidth = 2.0
    line_color.present? ? Theme.color(line_color).setStroke : UIColor.blackColor.setStroke

    path.stroke
  end
  
end