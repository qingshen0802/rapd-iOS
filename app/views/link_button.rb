class LinkButton < BaseButton

  def self.get_button(options = {})
    text_color = case options[:color]
    when :white
      UIColor.whiteColor
    else
      Theme.main_color
    end

    super(options.merge(color: UIColor.clearColor, text_color: text_color, font_size: 13.0))
  end

end