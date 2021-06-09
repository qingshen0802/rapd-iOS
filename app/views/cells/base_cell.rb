class BaseCell < UITableViewCell

  attr_accessor :settings, :outlets, :outlet_data, :delegate, :container_view
  include JsonLoader
  include ComponentLoader
  include PickerViewDataSource
  include PickerViewDelegate
  
  DISCLOSURE_TAG = 1000
      
  def json_file_name
    name
  end
  
  def json_object_type
    "cells"
  end
  
  def name
    self.class.to_s.underscore.gsub('_cell', '')
  end
  
  def app_delegate
    UIApplication.sharedApplication.delegate
  end
  
  def current_user
    app_delegate.current_user
  end

  def initWithStyle(style, reuseIdentifier: identifier)
    super(style, reuseIdentifier: identifier)
    self.container_view ||= self.contentView
    if !delayed_load_from_json && self.loadFromJson
      self.loadCell
      self.loadComponents
    end
    self
  end
  
  def loadCell
    if !settings[:background_image].nil?
      self.setBackgroundColor(Theme.color_from_image(settings[:background_image]))
    end
    if !settings[:background_color].nil?
      self.setBackgroundColor(settings[:background_color] == "clear" ? UIColor.clearColor : Theme.color(settings[:background_color]))
    end
  end
  
  def set_data(d = {})    
    if d[:disclosure]
      unless self.container_view.subviews.map(&:tag).include?(DISCLOSURE_TAG)
        disclosure = UIImageView.new
        disclosure.image = UIImage.imageNamed("images/rightarrow.png")
        disclosure.tag = DISCLOSURE_TAG
        self.container_view.addSubview(disclosure)
        disclosure.place_auto_layout(center_y: 0, trailing: -20, width: 8, height: 12)
      end
    end
    
    if d[:disable_selection]
      self.selectionStyle = UITableViewCellSelectionStyleNone
    else
      self.selectionStyle = UITableViewCellSelectionStyleDefault
    end
  end

  def textFieldShouldBeginEditing(textField)
    hide_all_select
    if textField.respond_to?(:picker_view) && !textField.picker_view.nil?
      textField.picker_view.hidden = false
      return false
    end
    true
  end

  def hide_all_select
    self.outlet_data.map do |element, data|
      element.picker_view.hidden = true if data[:has_options]
    end
  end

  def dismissKeyboard
    self.outlet_data.map do |outlet, data|
        outlet.resignFirstResponder
    end
  end

end