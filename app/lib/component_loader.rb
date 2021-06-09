module ComponentLoader
  def loadComponents
    self.outlets = {}
    self.outlet_data = {}
    
    settings[:elements].each_with_index do |element, tag|
      send("build#{element[:type].camelize}", element, tag)
    end
  end
  
  def buildView(element, tag)
    element_view = UIView.new
    element_view.tag = tag
    element_view.backgroundColor = Theme.color(element[:background_color]) if !element[:background_color].nil?
    element_view.alpha = element[:alpha] if !element[:alpha].nil?
    
    if element[:corner_radius]
      element_view.layer.cornerRadius = element[:corner_radius]
      element_view.layer.masksToBounds = true
    end
    
    if element[:border].present?
      element_view.layer.borderColor = UIColor.blackColor
      element_view.layer.borderWidth = 2.0
      element_view.clipsToBounds= true
    end
    
    if element[:circle]
      size = element[:autolayout][:width]
      
      element_view.bounds = CGRectMake(0, 0, size, size)
      element_view.layer.cornerRadius = size / 2
    end

    element_view.hidden = element[:hidden]
    self.container_view.addSubview(element_view)
    element_view.place_auto_layout(element[:autolayout])
    self.outlets[element[:outlet]] = element_view
    self.outlet_data[element_view] = element
  end
  
  def buildLabel(element, tag)
    label = UILabel.new
    label.tag = tag
    label.text = element[:content]
    label.font = Fonts.font_named(element[:font][:name], element[:font][:size])
    label.textColor = Theme.color(element[:font][:color])
    label.numberOfLines = element[:number_of_lines].present? ? element[:number_of_lines] : 0
    label.userInteractionEnabled = element[:copyable]
    label.backgroundColor = Theme.color(element[:background_color]) if !element[:background_color].nil?
    
    if element[:corner_radius]
      label.layer.cornerRadius = element[:corner_radius]
      label.layer.masksToBounds = true
    end    
    
    if element[:text_alignment]
      label.textAlignment = case element[:text_alignment]
      when 'center'
        NSTextAlignmentCenter
      when 'left'
        NSTextAlignmentLeft
      when 'right'
        NSTextAlignmentRight
      end      
    else
      label.textAlignment = NSTextAlignmentLeft
    end
    
    label.hidden = element[:hidden]
    
    self.container_view.addSubview(label)
    label.place_auto_layout(element[:autolayout])

    self.outlets[element[:outlet]] = label
    self.outlet_data[label] = element



  end
  
  def buildImage(element, tag)
    image = UIImageView.new
    image.tag = tag
    image.image = UIImage.imageNamed(element[:name])
    
    if element[:corner_radius]
      image.layer.cornerRadius = element[:corner_radius]
      image.layer.masksToBounds = true
    end
    
    self.container_view.addSubview(image)
    image.place_auto_layout(element[:autolayout])
    
    self.outlets[element[:outlet]] = image
    self.outlet_data[image] = element
  end

  def buildScrollView(element, tag)
    scroll_view = UIScrollView.alloc.init
    scroll_view.tag = tag
    scroll_view.frame = CGRectMake(0, 0, App.window.frame.size.width, element[:autolayout][:height])

    scroll_view.pagingEnabled = true
    scroll_view.backgroundColor = UIColor.blackColor

    scroll_view.showsHorizontalScrollIndicator = false
    scroll_view.showsVerticalScrollIndicator = false

    scroll_view.delegate = self
    self.container_view.addSubview(scroll_view)
    scroll_view.place_auto_layout(element[:autolayout])

    self.outlets[element[:outlet]] = scroll_view
    self.outlet_data[scroll_view] = element
  end 

  def buildPageControl(element, tag)
    page_control = UIPageControl.alloc.init
    page_control.tag = tag
    page_control.frame = CGRectMake(0, 0, App.window.frame.size.width, element[:autolayout][:height])

    self.container_view.addSubview(page_control)
    page_control.place_auto_layout(element[:autolayout])

    self.outlets[element[:outlet]] = page_control
    self.outlet_data[page_control] = element
  end 
  
  def buildButton(element, tag)
    button = UIButton.new
    button.tag = tag
    button.setBackgroundColor(element[:color].nil? ? UIColor.clearColor : Theme.color(element[:color]), forState: UIControlStateNormal)
    button.setTitle(element[:title], forState: UIControlStateNormal)
    
    if element[:title_color]
      button.setTitleColor(Theme.color(element[:title_color]), forState: UIControlStateNormal)
    end
    
    if element[:font].present?
      button.setTitleColor(Theme.color(element[:font][:color]), forState: UIControlStateNormal) unless element[:font].nil? || element[:font][:color].nil?
      button.titleLabel.font = Fonts.font_named(element[:font][:name], element[:font][:size]) unless element[:font][:name].nil?
    else
      button.titleLabel.font = Fonts.font_named("Roboto-Bold", 16)
    end
    
    button.addTarget(self, action: NSSelectorFromString(element[:action]), forControlEvents: UIControlEventTouchUpInside)
    
    if element[:link_style]
      button.titleLabel.attributedText = element[:title].underline # sugarcube gem
    end
    
    if element[:corner_radius]
      button.layer.cornerRadius = element[:corner_radius]
      button.clipsToBounds = true
    end
    
    if element[:checkbox]
      button.setBackgroundColor(UIColor.colorWithPatternImage(UIImage.imageNamed("images/checkbox.png")), forState: UIControlStateNormal)
    end
    
    if element[:image]
      button.setImage(UIImage.imageNamed(element[:image]), forState: UIControlStateNormal)
    end

    if element[:border]
      button.layer.setBorderWidth(element[:border][:width])
      button.layer.setBorderColor(Theme.color(element[:border][:color]))
    end 
    self.container_view.addSubview(button)
    button.attach_to_super_super_view = element[:autolayout][:attach_to_super_super_view].present? ? element[:autolayout][:attach_to_super_super_view] : false
    button.place_auto_layout(element[:autolayout])
    self.outlets[element[:outlet]] = button
    self.outlet_data[button] = element
  end
  
  def buildTextField(element, tag)
    text_field = element[:curency_field] ? BKCurrencyTextField.new : UITextField.new
    text_field = VMaskTextField.new if element[:mask]
    text_field.tag = tag
    
    if element[:placeholder].present?
      text_field.attributedPlaceholder = NSAttributedString.alloc.initWithString(
        element[:placeholder], attributes:{NSForegroundColorAttributeName =>  Theme.secondary_color}
      )
    end
    
    text_field.delegate = self
    text_field.backgroundColor = element[:background_color] ? Theme.color(element[:background_color]) : Theme.light_gray
    
    if element[:disabled]
      text_field.inputView = UIView.alloc.initWithFrame(CGRectZero)
    end

    if element[:font].present?
      text_field.font = Fonts.font_named(element[:font][:name], element[:font][:size])
      text_field.textColor = Theme.color(element[:font][:color])
    else
      text_field.font = Fonts.font_named("Roboto", 16)
    end

    if !element[:auto_capitalization]
      text_field.autocorrectionType = UITextAutocorrectionTypeNo
      text_field.autocapitalizationType = UITextAutocapitalizationTypeNone      
    end
    
    if element[:password]
      text_field.secureTextEntry = true
    end
    
    if element[:value].present?
      text_field.text = element[:value]
    end
    
    if element[:number_only]
      text_field.keyboardType = UIKeyboardTypeNumberPad
      text_field.inputAccessoryView = doneToolbar
    end
    
    if element[:email_field]
      text_field.keyboardType = UIKeyboardTypeEmailAddress
    end
    
    if element[:text_alignment]
      text_field.textAlignment = case element[:text_alignment]
      when 'center'
        NSTextAlignmentCenter
      when 'left'
        NSTextAlignmentLeft
      when 'right'
        NSTextAlignmentRight
      end      
    else
      text_field.textAlignment = NSTextAlignmentLeft
    end
    
    padding_view = UIView.new
    padding_view.frame = CGRectMake(0, 0, 5, 20)
    text_field.leftView = padding_view;
    text_field.leftViewMode = UITextFieldViewModeAlways
    
    text_field.borderStyle = UITextBorderStyleRoundedRect
    text_field.layer.borderColor = Theme.light_gray.CGColor
    text_field.layer.borderWidth = 2
    text_field.layer.cornerRadius = 5

    if element[:background_color]
      text_field.backgroundColor = Theme.color(element[:background_color])
    end 

    if element[:has_options]
      picker_view = TextPickerView.new
      picker_view.outlet = element[:outlet]
      picker_view.text_field = text_field
      picker_view.dataSource = self
      picker_view.delegate = self
      self.view.addSubview(picker_view)
      picker_view.place_auto_layout(leading: 0, trailing: 0, height: 200, bottom: -50)
      picker_view.hidden = true

      if element[:picker_color]
        picker_view.backgroundColor = Theme.color(element[:picker_color])
      else
        picker_view.backgroundColor = Theme.main_color        
      end
      
      text_field.picker_view = picker_view
    end

    self.container_view.addSubview(text_field)
    text_field.place_auto_layout(element[:autolayout])
    self.outlets[element[:outlet]] = text_field
    self.outlet_data[text_field] = element
  end
  
  def doneToolbar
    tool_bar = UIToolbar.alloc.initWithFrame(CGRectMake(0, 0, 320, 50))
    tool_bar.tintColor = Theme.main_color
    tool_bar.items = [
                        UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemFlexibleSpace, target:nil, action:nil),
                        UIBarButtonItem.alloc.initWithTitle("OK", style:UIBarButtonItemStyleDone, target:self, action:NSSelectorFromString("dismissKeyboard"))
                     ]
    tool_bar.sizeToFit
  end
  
  def buildTextArea(element, tag)
    text_area = element[:underlined] ? UnderlinedTextView.new : UITextView.new
    text_area.tag = tag
    text_area.placeholder = element[:placeholder]
    text_area.placeholderColor = Theme.secondary_color
    text_area.delegate = self
    text_area.contentInset = UIEdgeInsetsMake(8,5,-8,-5)
    text_area.inputAccessoryView = doneToolbar unless element[:disabled]
    text_area.backgroundColor = element[:background_color] ? Theme.color(element[:background_color]) : Theme.light_gray

    if !element[:auto_capitalization]
      text_area.autocorrectionType = UITextAutocorrectionTypeNo
      text_area.autocapitalizationType = UITextAutocapitalizationTypeNone      
    end
    
    if element[:text_alignment]
      text_area.textAlignment = case element[:text_alignment]
      when 'center'
        NSTextAlignmentCenter
      when 'left'
        NSTextAlignmentLeft
      when 'right'
        NSTextAlignmentRight
      end      
    else
      text_area.textAlignment = NSTextAlignmentLeft
    end

    if element[:font].present?
      text_area.font = Fonts.font_named(element[:font][:name], element[:font][:size])
      text_area.textColor = Theme.color(element[:font][:color])
    end

    if element[:disabled]
      text_area.inputView = UIView.alloc.initWithFrame(CGRectZero)
    end
    
    text_area.layer.borderColor = Theme.light_gray.CGColor
    text_area.layer.borderWidth = 2
    text_area.layer.cornerRadius = 5
        
    self.container_view.addSubview(text_area)
    text_area.place_auto_layout(element[:autolayout])
    self.outlets[element[:outlet]] = text_area
    self.outlet_data[text_area] = element
  end  
  
  def buildTableView(element, tag)
    self.table_data ||= []
    self.table_view_settings = element
    
    self.data_table_view = UITableView.new
    self.data_table_view.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0) unless element[:skip_inset]
    self.data_table_view.dataSource = self
    self.data_table_view.delegate = self
    self.cell_identifiers = element[:cells].map{|name, height| "#{name}_cell"}
    self.data_table_view.hidden = element[:hidden]
    self.register_cells(cell_identifiers)
    self.container_view.addSubview(self.data_table_view)

    self.data_table_view.place_auto_layout(element[:autolayout])
    
    if element[:disable_scroll]
      self.data_table_view.alwaysBounceVertical = false
      self.data_table_view.scrollEnabled = false
    end
    
    if element[:background_color]
      self.data_table_view.backgroundView = nil    
      self.data_table_view.backgroundColor = element[:background_color] == "clear" ? UIColor.clearColor : Theme.color(element[:background_color])
    end
    
    if element[:border].present?
      self.data_table_view.layer.borderColor = Theme.color(element[:border][:color]).CGColor
      self.data_table_view.layer.borderWidth = element[:border][:size]
      self.data_table_view.clipsToBounds = true
    end    
    
    if element[:corner_radius]
      self.data_table_view.layer.cornerRadius = element[:corner_radius]
      self.data_table_view.layer.masksToBounds = true
    end    
    
    self.data_table_view.separatorColor = UIColor.clearColor if element[:hide_separator]
    
    self.data_table_view.separatorInset = UIEdgeInsetsMake(0, 70, 0, 0) if element[:change_separator]

    self.data_table_view.separatorInset = UIEdgeInsetsMake(0, 45, 0, 0) if element[:change_separator_no_icon]
    
    self.outlet_data["table_view"] = element
  end
  
  def buildControl(element, tag)
    control = UIControl.new
    control.tag = tag
    control.build_child_elements(element) unless element[:elements].nil?
    control.backgroundColor = Theme.color(element[:background_color]) if !element[:background_color].nil?
    control.addTarget(self, action: NSSelectorFromString(element[:action]), forControlEvents: UIControlEventTouchUpInside) unless element[:action].nil?

    self.container_view.addSubview(control)
    control.place_auto_layout(element[:autolayout])
    self.outlets[element[:outlet]] = control
    self.outlet_data[control] = element
  end
  
  def buildSwitch(element, tag)
    switch = UISwitch.new
    switch.tag = tag
    switch.addTarget(self, action: NSSelectorFromString(element[:action]), forControlEvents:UIControlEventValueChanged)
    self.container_view.addSubview(switch)
    switch.place_auto_layout(element[:autolayout])
    self.outlets[element[:outlet]] = switch
    self.outlet_data[switch] = element
  end
  
  def buildSearchField(element, tag)
    search = UISearchBar.new
    search.tag = tag
    search.delegate = self
    search.tintColor = UIColor.blackColor
    search.hidden = element[:hidden]

    if element[:background_color]
      search.barStyle = UISearchBarStyleProminent
      search.backgroundImage = UIImage.new
      search.backgroundColor = Theme.color(element[:background_color])
    end 

    if element[:text_field_color]
      text_field = search.valueForKey("searchField")
      text_field.backgroundColor = Theme.color(element[:text_field_color]) 
    end 

    if element[:text_color]
      search_field = search.valueForKey("searchField")
      search_field.tintColor = Theme.color(element[:text_color])

      if search_field.respondsToSelector(:setAttributedPlaceholder)
        search_field.setAttributedPlaceholder(NSMutableAttributedString.alloc.initWithString("Search"), attributes: NSForegroundColorAttributeName(Theme.color[:text_color]))
      end 

    end 

    search.placeholder = element[:placeholder]

    self.container_view.addSubview(search)
    search.place_auto_layout(element[:autolayout])
    self.outlets[element[:outlet]] = search
    self.outlet_data[search] = element
  end
  
  def buildTopTabBar(element, tag)
    top_tab_bar = TopTabBar.new
    top_tab_bar.tag = tag
    top_tab_bar.delegate = self

    self.container_view.addSubview(top_tab_bar)
    top_tab_bar.place_auto_layout(element[:autolayout])
    top_tab_bar.load_subviews
    top_tab_bar.backgroundColor = Theme.main_color

    self.outlets[element[:outlet]] = top_tab_bar
    self.outlet_data[top_tab_bar] = element
  end
  
  def buildCircularSlider(element, tag)    
    frame = CGRectMake(UIScreen.mainScreen.bounds.origin.x, UIScreen.mainScreen.bounds.origin.y, element[:autolayout][:width], element[:autolayout][:height])
    slider = EFCircularSlider.alloc.initWithFrame(frame)
    slider.addTarget(self, action:NSSelectorFromString("sliderChanged:"), forControlEvents:UIControlEventValueChanged)
    slider.handleType = 0
    slider.lineWidth = element[:border][:width]
    slider.unfilledColor = Theme.color(element[:border][:unfilled_color])
    slider.filledColor = Theme.color(element[:border][:filled_color])
    slider.minimumValue = 0
    slider.maximumValue = 100
    
    self.container_view.addSubview(slider)
    slider.place_auto_layout(element[:autolayout])
    
    self.outlets[element[:outlet]] = slider
    self.outlet_data[slider] = element
  end
  
  def buildChart(element, tag)
    chart = BEMSimpleLineGraphView.new
    chart.dataSource = self
    chart.delegate = self

    chart.enablePopUpReport =  true;


    if element[:y_axis_label]
      chart.enableYAxisLabel = true 
    end 


    if element[:bezier_curve]
      chart.enableBezierCurve = true
    end
    
    if element[:top_background_color]
      chart.colorTop = Theme.color(element[:top_background_color])
    end
    
    if element[:bottom_background_color]
      chart.colorBottom = Theme.color(element[:bottom_background_color])
    end    
    
    if element[:line_width]
      chart.widthLine = element[:line_width]
    end
    
    if element[:point_size]
      chart.sizePoint = element[:point_size]
    end
    
    if element[:x_axis_color]
      chart.colorXaxisLabel = Theme.color(element[:x_axis_color])
    end
    
    if element[:y_axis_color]
      chart.colorYaxisLabel = Theme.color(element[:y_axis_color])
    end    

    
    self.container_view.addSubview(chart)
    chart.place_auto_layout(element[:autolayout])
    
    self.outlets[element[:outlet]] = chart
    self.outlet_data[chart] = element
  end
  
  def buildPinView(element, tag)
    pin_view = PinView.new
    pin_view.tag = tag
    pin_view.delegate = self
    pin_view.border_color = element[:border_color] || "333333"
    
    self.container_view.addSubview(pin_view)
    pin_view.place_auto_layout(element[:autolayout])
    pin_view.load_subviews

    self.outlets[element[:outlet]] = pin_view
    self.outlet_data[pin_view] = element    
  end

end