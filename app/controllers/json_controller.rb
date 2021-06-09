class JsonController < BaseController
  
  attr_accessor :settings, :outlets, :outlet_data, :table_data, 
                :data_table_view, :cell_identifiers, :table_view_settings,
                :profile

  include JsonLoader
  include ComponentLoader
  include TableViewDataSource
  include TableViewDelegate
  include SearchDelegate
  include PickerViewDataSource
  include PickerViewDelegate
  
  def json_file_name
    name
  end
  
  def json_object_type
    "controllers"
  end
  
  def viewDidLoad
    super
    self.container_view ||= self.view
    if loadFromJson
      loadController
      loadComponents
    end
  end
  
  def name
    self.class.to_s.underscore.gsub("_controller", "")
  end  
  
  def presentController(controller)
    screen_manager.send("present_#{controller}")
  end
  
  def loadController
    self.container_view.backgroundColor = Theme.color(settings[:background_color] || "FFFFFF")
    loadBlurEffect if settings[:blur_effect]
  end
  
  def loadBlurEffect
    blur_effect = UIBlurEffect.effectWithStyle(UIBlurEffectStyleExtraLight)
    blur_effect_view = UIVisualEffectView.alloc.initWithEffect(blur_effect)
    self.view.setOpaque(false)
    self.view.addSubview(blur_effect_view)
    blur_effect_view.place_auto_layout(top: 0, bottom: 0, leading: 0, trailing: 0)
    self.container_view = blur_effect_view

    self.view.backgroundColor = UIColor.clearColor
    self.setModalPresentationStyle(UIModalPresentationFullScreen) # UIModalPresentationFullScreen    
  end
    
  def canEdit?(textField)
    true
  end
  
  def hide_all_select
    self.outlet_data.map do |element, data|
      element.picker_view.hidden = true if data[:has_options]
    end
  end
  
  def textFieldShouldBeginEditing(textField)
    hide_all_select
    if textField.respond_to?(:picker_view) && !textField.picker_view.nil?
      textField.picker_view.hidden = false
      false
    elsif canEdit?(textField)
      data = self.outlet_data[textField]
      unless data[:scroll_top].nil? || self.form_view.nil?
        self.form_view.setContentOffset(CGPointMake(0, data[:scroll_top]), animated: true)
      end
      true
    end
  end

  def textViewShouldBeginEditing(textView)
    if canEdit?(textView)
      data = self.outlet_data[textView]
      unless data[:scroll_top].nil? || self.form_view.nil?
        self.form_view.setContentOffset(CGPointMake(0, data[:scroll_top]), animated: true)
      end
      true
    end
  end

  def textFieldShouldReturn(textField)
    data = self.outlet_data[textField]
    if data[:next_outlet].blank?
      textField.resignFirstResponder
      self.form_view.resetPosition unless self.form_view.blank?
    else
      self.outlets[data[:next_outlet]].becomeFirstResponder
    end
    true    
  end

  def dismissKeyboard
    self.outlet_data.map do |outlet, data|
      if data["type"] == "text_field"
        outlet.resignFirstResponder
      elsif data["type"] == "text_area"
        outlet.resignFirstResponder        
      end
    end

    self.form_view.resetPosition unless self.form_view.nil?
  end
  
  def load_profile
    if @profile_id.present?
      profile_manager = ProfileManager.shared_manager 
      profile_manager.delegate = self
      profile_manager.fetch(@profile_id)
    end
  end
  
  def item_fetched(resource)
    if resource.is_a?(Profile)
      self.profile = profile
    end
  end
  
end