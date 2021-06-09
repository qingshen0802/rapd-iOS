class Fonts

  # To find your font family name
  # UIFont.familyNames.sort
  # UIFont.fontNamesForFamilyName 'St Marie'

  def self.normal_font(size = 16.0)
    UIFont.systemFontOfSize(size, weight: 0)
  end

  def self.normal_font_bold(size = 16.0)
    UIFont.systemFontOfSize(size, weight: 0.2)
  end  
  
  def self.font_named(name, size = 16.0)
    UIFont.fontWithName(name, size: size)
  end

end