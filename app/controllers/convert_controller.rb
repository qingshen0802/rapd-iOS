class ConvertController < JsonController

  attr_accessor :form_view, :from_currency_ids, :to_currency_ids, :from_currency, 
                :to_currency, :amount, :wallets, :conversion_request
  
  def viewDidLoad
    self.title = "Converter"
        
    self.form_view = FormView.get_form(delegate: self)
    self.view.addSubview(self.form_view)
    self.form_view.place_auto_layout(top: 0, bottom: 0, leading: 0, trailing: 0)
    self.container_view = self.form_view
    
    super

    back_button = self.load_back_button
    unless settings[:back_button].nil?
      back_button.setImage(UIImage.imageNamed(settings[:back_button]), forState: UIControlStateNormal)
    end
        
    title_label = self.load_title
    unless settings[:title_color].nil?
      title_label.textColor = Theme.color(settings[:title_color])
    end
    
    self.outlets["convert_button"].enabled = false
    load_wallets
  end
  
  def load_wallets
    wallet_manager = WalletManager.shared_manager
    wallet_manager.delegate = self
    wallet_manager.fetch_all(profile_id: profile.remote_id, withdrawable: true)
  end
  
  def items_fetched(wallets)
    self.wallets = wallets
    self.outlets["convert_button"].enabled = true
  end  
  
  def picker_view_data
    c = RestClient.new
    self.to_currency_ids = self.from_currency_ids = c.get("#{app_delegate.base_url}/api/currencies/names.json", app_delegate.api_access_token) if self.from_currency_ids.blank?
    self.from_currency ||= "R$"
    self.to_currency   ||= "US$"
    
    @picker_data ||= {
      "from_currency_select" => [from_currency_ids.keys.sort],
      "to_currency_select" => [to_currency_ids.keys.sort]
    }

    @picker_data
  end  
  
  def canEdit?(textField)
    data = self.outlet_data[textField]
    data[:outlet] != 'to_amount_field'
  end
  
  def pickerView(pickerView, didSelectRow:row, inComponent:component)
    super(pickerView, didSelectRow:row, inComponent:component)
    
    if pickerView.outlet == "from_currency_select"
      self.from_currency = picker_view_data["from_currency_select"].first[row]
    else
      self.to_currency = picker_view_data["to_currency_select"].first[row]
    end
    
    attempt_conversion
  end
  
  def attempt_conversion
    self.amount = self.outlets["from_amount_field"].text.to_i
    if amount > 0
      c = RestClient.new
      path = "#{app_delegate.base_url}/api/currencies/convert.json?buying=0&needs_normalization=1&from_currency_id=#{self.from_currency_ids[from_currency]}&to_currency_id=#{self.to_currency_ids[to_currency]}&amount=#{amount}"
      response = c.get(path, app_delegate.api_access_token)  
      self.outlets["to_amount_field"].text = response["to_amount"].to_s
    end
  end
  
  def textFieldDidEndEditing(textField)
    attempt_conversion
  end
  
  def convert
    attempt_conversion
    if self.outlets["to_amount_field"].text.to_f > 0
      submit_conversion
    end
  end
  
  def submit_conversion
    if valid_conversion?
      self.conversion_request = ConversionRequest.new
      self.conversion_request.profile_id = self.profile.remote_id
      self.conversion_request.from_currency_id = self.from_currency_ids[from_currency]
      self.conversion_request.to_currency_id = self.to_currency_ids[to_currency]
      self.conversion_request.from_amount = self.outlets["from_amount_field"].text
      self.conversion_request.to_amount = self.outlets["to_amount_field"].text
      
      manager = ConversionRequestManager.shared_manager
      manager.delegate = self
      manager.create_resource(conversion_request)
    else
      self.app_delegate.display_error("Não há saldo o suficiente para realizar esta conversão")
    end
  end
  
  def valid_conversion?
    wallet = self.wallets.map{|w| print "#{w.wallet_type.currency.short_name} != #{from_currency}\n"; w if w.wallet_type.currency.short_name == from_currency}.compact.first
    if wallet.present? && wallet.balance.to_f > self.outlets["from_amount_field"].text.to_f
      true
    else
      false
    end
  end
  
  def resource_created(resource)
    self.app_delegate.display_message("Sucesso", "Moeda convertida com sucesso")
    self.navigationController.popViewControllerAnimated(true)
  end

end