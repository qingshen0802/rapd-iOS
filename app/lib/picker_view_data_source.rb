module PickerViewDataSource
  
  def picker_view_data
    {}
  end

  def numberOfComponentsInPickerView(pickerView)
    picker_view_data[pickerView.outlet].count
  end

  def pickerView(pickerView, numberOfRowsInComponent: component)
    picker_view_data[pickerView.outlet][component].count
  end

  def pickerView(pickerView, titleForRow:row, forComponent:component)
    picker_view_data[pickerView.outlet][component][row]
  end

end