class MainButton < BaseButton

  def self.get_button(options = {})
    case options[:color]
    when :white
      color = UIColor.whiteColor
      text_color = Theme.main_color
    else
      color = Theme.main_color
      text_color = UIColor.whiteColor
    end

    super(options.merge(corner: 4.0, color: color, text_color: text_color))
  end  

end