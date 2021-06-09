class BaseButton < UIButton

  def self.get_button(options = {})
    button = new

    button.addTarget(options[:target], action: NSSelectorFromString(options[:action]), forControlEvents: UIControlEventTouchUpInside) unless options[:target].nil?
    button.setBackgroundImage(image_from_color(Theme.tertiary), forState: UIControlStateDisabled)
    button.setBackgroundImage(image_from_color(options[:color]), forState: UIControlStateNormal) unless options[:color].nil?

    button.setTitle(options[:title], forState: UIControlStateNormal) unless options[:title].nil?
    button.setTitleColor(options[:text_color], forState: UIControlStateNormal) unless options[:text_color].nil?

    unless options[:corner].nil?
      button.layer.cornerRadius = options[:corner]
      button.clipsToBounds = true
    end

    unless options[:font_size].nil?
      button.titleLabel.font = UIFont.systemFontOfSize(options[:font_size])
    end

    button
  end

  def self.image_from_color(color)
    rect = CGRectMake(0, 0, 1, 1)
    UIGraphicsBeginImageContext(rect.size)
    context = UIImage.UIGraphicsGetCurrentContext
    CGContextSetFillColorWithColor(context, color.CGColor)
    CGContextFillRect(context, rect)
    img = UIImage.UIGraphicsGetImageFromCurrentImageContext
    UIImage.UIGraphicsEndImageContext
    img
  end

end