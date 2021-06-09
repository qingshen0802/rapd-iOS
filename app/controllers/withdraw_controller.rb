class WithdrawController < JsonController
  
  attr_accessor :profile, :wallet, :available_amount, :form_view, 
                :withdrawal_amount, :withdrawal_request
  
  def viewDidLoad
    self.navigationController.navigationBar.hidden = true
    self.title = "Resgatar"
    super

    back_button = self.load_back_button
    unless settings[:back_button].nil?
      back_button.setImage(UIImage.imageNamed(settings[:back_button]), forState: UIControlStateNormal)
    end
        
    title_label = self.load_title
    unless settings[:title_color].nil?
      title_label.textColor = Theme.color(settings[:title_color])
    end
  end
  
  def viewDidAppear(animated)
    super(animated)
    load_wallets
  end
  
  def load_wallets
    wallet_manager = WalletManager.shared_manager
    wallet_manager.delegate = self
    wallet_manager.fetch_all(profile_id: profile.remote_id, withdrawable: true)
  end
  
  def items_fetched(wallets)
    if self.wallet.nil?
      self.wallet = wallets.first
    else
      self.wallet = wallets.map{|w| w if w.remote_id == self.wallet.remote_id}.compact.first
    end
    present_wallet
  end  
  
  def present_wallet
    if self.wallet.present?
      self.move_slider_to_value(0.0)
      self.available_amount = self.wallet.balance
      self.withdrawal_amount = 0.0
      
      self.outlets["wallet_label"].text = self.wallet.wallet_type.name
      self.outlets["value_field"].text = "#{self.wallet.wallet_type.currency.short_name} 0,00"
      self.outlets["percentage_label"].text = "0 %"
    else
      self.app_delegate.display_error("Nenhuma carteira disponível")
    end
  end
  
  def sliderChanged(slider)
    total = slider.currentValue.to_f > 100 ? 100 : slider.currentValue.to_f
    percentage = (total / 100.0)
    self.withdrawal_amount = (percentage * self.available_amount).ceil

    self.outlets["value_field"].text = "#{self.wallet.wallet_type.currency.short_name} #{withdrawal_amount.to_i},00"
    self.outlets["withdraw_button"].setTitle("SOLICITAR #{self.wallet.wallet_type.currency.short_name} #{withdrawal_amount.to_i},00", forState: UIControlStateNormal)
    self.outlets["percentage_label"].text = "#{(percentage * 100).to_i} %"
  end
    
  def textField(textField, shouldChangeCharactersInRange: range, replacementString: string)
    result_string = textField.text.stringByReplacingCharactersInRange(range, withString:string)
    
    if string =~ /[0-9,]/ || is_backspace?(string, range)
      value = result_string.gsub(/[^0-9,]/, '').gsub(',', '.').to_f
      if value <= self.available_amount
        self.withdrawal_amount = value
        move_slider_to_value(value)
        true
      else
        false
      end
    else
      false
    end
  end
  
  def move_slider_to_value(value)
    slider = self.outlets["amount_slider"]
    
    if value.to_f == 0.0
      value_percentage = 0.0
      slider_angle = 360.0
    else
      value_percentage = (value.to_f / self.available_amount.to_f)      
      slider_angle = 360.0 - (value_percentage * 360.0)      
    end
    
    slider.currentValue = value_percentage * 100.0
    
    if slider_angle.to_i < 353.0
      point = slider.pointFromAngle(slider_angle.to_i)
    else
      point = slider.pointFromAngle(353.0)
    end
    slider.moveHandle(point)
    
    self.outlets["percentage_label"].text = "#{(value_percentage * 100.0).to_i} %"    
    self.outlets["withdraw_button"].setTitle("SOLICITAR #{self.wallet.wallet_type.currency.short_name} #{sprintf('%.2f', value.to_f).to_s.gsub('.', ',')}", forState: UIControlStateNormal)
  end
  
  def is_backspace?(string, range)
    non_numeric_length = self.wallet.wallet_type.currency.short_name.length + 1 # i.e. R$, US$
    string == "" && range.location >= non_numeric_length && range.length == 1
  end

  def withdraw
    if self.withdrawal_amount.to_f == 0.0
      self.app_delegate.display_error("Quantia para retirada deve ser maior que zero")
    else
      create_withdrawal_request
    end
  end

  def toggle_wallet
    wallets_controller = WalletsController.new
    wallets_controller.delegate = self
    wallets_controller.profile = self.profile
    self.presentModalViewController(wallets_controller, animated: true)
  end
  
  def select_wallet(wallet)
    self.wallet = wallet
    present_wallet
  end
  
  def create_withdrawal_request
    if self.withdrawal_request.nil?
      self.withdrawal_request = WithdrawalRequest.new({
        amount: withdrawal_amount,
        profile_id: profile.remote_id,
        wallet_id: wallet.remote_id
      })      
    else
      self.withdrawal_request.update_attributes({
        amount: withdrawal_amount,
        profile_id: profile.remote_id,
        wallet_id: wallet.remote_id
      })      
    end
    
    withdrawal_request_manager = WithdrawalRequestManager.shared_manager
    withdrawal_request_manager.delegate = self
    
    if withdrawal_request.new_record?
      withdrawal_request_manager.create_resource(withdrawal_request)
    else
      withdrawal_request_manager.update_resource(withdrawal_request)
    end
  end
  
  def resource_created(withdrawal_request)
    self.withdrawal_request = withdrawal_request
    select_destination
  end
  
  def resource_updated(withdrawal_request)
    self.withdrawal_request = withdrawal_request
    select_destination
  end
  
  def select_destination
    c = WithdrawalDestinationController.new
    c.withdrawal_request = withdrawal_request
    c.profile = self.profile
    self.navigationController.pushViewController(c, animated: true)
    
    self.withdrawal_request = WithdrawalRequest.new
  end

end