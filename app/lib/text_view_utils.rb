class UnderlinedTextView < UITextView
  
  def drawRect(rect)
    startingPoint   = CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect))
    endingPoint     = CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect))
    path = UIBezierPath.new
    
    path.moveToPoint(startingPoint)
    path.addLineToPoint(endingPoint)
    path.lineWidth = 2.0
    UIColor.blackColor.setStroke
    path.stroke
  end
  
end