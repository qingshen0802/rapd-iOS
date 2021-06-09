class MainWalletCell < BaseCell
  
  attr_accessor :wallet, :period_type, :delegate
  
  def set_data(data = {})
    super(data)
    self.wallet = data[:wallet]
    self.period_type = data[:period_type]

    self.outlets["balance_label"].text = wallet.human_balance
    self.outlets["short_name_label"].text = wallet.short_name
    self.outlets["period_select"].text = period_label_for_value(period_type)
  end
  
  def delayed_load_from_json
    true
  end  
  
  def period_options
    {
      Time.now.strftime("%Y") => 'this_year',
      "7 dias" => 7,
      "15 dias" => 15,
      "30 dias" => 30,
    }
  end  
  
  def period_label_for_value(value)
    period_options.map{|k, v| k if value == v}.compact.first
  end
  
  def picker_view_data
    {"period_select" => [period_options.keys]}
  end  
  
  def pickerView(pickerView, didSelectRow:row, inComponent:component)
    super(pickerView, didSelectRow:row, inComponent:component)
    period_label = picker_view_data["period_select"].first[row]
    self.period_type = period_options[period_label]
    self.outlets["period_select"].text = period_label
    self.delegate.filter_period(period_type)
  end  
  
  def view
    self.delegate.view
  end
  
end