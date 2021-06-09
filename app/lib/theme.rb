class Theme

  def self.main_color
    color("F15E4F") # Orange_17pm
  end

  def self.secondary_color
    color("364655") # Midnight / Dark Grey
  end
  
  def self.tertiary_color
    color("9AA2AA") # Blue_Silver / Light Grey
  end
  
  def self.light_gray
    color("F4F5F6") # TextField Light Grey
  end

  def self.black_color
    color("000000") # Black Color
  end

  def self.color(rgb)
    case rgb
    when :clear
      UIColor.clearColor
    else
      red = rgb[0, 2].to_i(16)
      green = rgb[2, 2].to_i(16)
      blue = rgb[4, 2].to_i(16)

      UIColor.colorWithRed(red.to_f/255.0, green: green.to_f/255.0, blue: blue.to_f/255.0, alpha: 1)      
    end
  end
  
  def self.color_from_image(image_name)
    UIColor.colorWithPatternImage(UIImage.imageNamed(image_name))
  end

end