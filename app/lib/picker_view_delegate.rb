module PickerViewDelegate

  def pickerView(pickerView, didSelectRow:row, inComponent:component)
    selected_value = picker_view_data[pickerView.outlet][component][row]
    
    unless pickerView.text_field.nil?
      pickerView.text_field.text = selected_value
      pickerView.hidden = true
    end
  end

end