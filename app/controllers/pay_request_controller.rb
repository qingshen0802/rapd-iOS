class PayRequestController < JsonController
  
  attr_accessor :profile, :form_view, :wallets, :selected_wallet, :current_profile, :wallet_controller, :transaction_type, :payment, :from_transaction
  
  def viewDidLoad
    self.title = ""
    self.form_view = FormView.get_form(delegate: self)
    self.view.addSubview(self.form_view)
    self.form_view.place_auto_layout(top: 0, bottom: 0, leading: 0, trailing: 0)
    self.container_view = self.form_view
    
    super
    
    self.outlets['profile_selected_field'].text = profile.full_name
   
    self.outlets['profile_selected_field'].delegate = self
    self.transaction_type = 'transaction_request'

    self.outlets['value_field'].placeholder = "Valor"
    load_current_profile
    load_wallets
  end
  
  def viewWillAppear animated
    self.navigationController.navigationBar.hidden = true
    loadtitle
    self.wallet_controller.load_profile
    if (self.from_transaction)
      self.from_transaction = false
      self.navigationController.popViewControllerAnimated(true)      
    end
  end

  def loadtitle
    label = UILabel.new
    self.view.addSubview(label)
    label.place_auto_layout(top: 30, width: 270, height: 45, leading: 20)
    label.font = Fonts.font_named("Roboto-Black", 30)
    label.text = "Enviar ou Solicitar"
    label.textAlignment = NSTextAlignmentLeft
    label.textColor = UIColor.blackColor
  end

  def select_wallet(wallet)
    self.selected_wallet = wallet
    self.outlets['value_field'].numberFormatter.currencyCode = self.selected_wallet.wallet_type.currency.currency_code
    self.outlets['value_field'].text = payment ? "#{selected_wallet.short_name}#{payment}" : ""
  end
  
  def load_wallets
    show_loading("Carregando...")
    
    wallet_manager = WalletManager.shared_manager
    wallet_manager.delegate = self
    wallet_manager.fetch_all(profile_id: self.app_delegate.current_profile_id, withdrawable: true)
  end
  
  def items_fetched(wallets)
    self.wallets = wallets
    self.wallets.each do |wallet|
      if wallet.is_default == true
        select_wallet(wallet)
      end
    end
    dismiss_loading
  end
  
  def item_fetched(item)
    if item.is_a? Profile
      self.current_profile = item
      
      load_wallets
    end
  end
  
  def send_payment
    self.transaction_type = 'transaction_request'
    
    if selected_wallet.blank? 
      self.app_delegate.display_message("Error","Please choose wallet")
    else       
      if outlets['value_field'].text == ""
        self.app_delegate.display_message("Error","Please input valid amount")
      elsif app_delegate.current_profile_id.to_s == profile.remote_id.to_s
        self.app_delegate.display_message("Error","Please select another profile")
      else
        transaction = RapdTransaction.new
        transaction.from_profile_id = app_delegate.current_profile_id
        transaction.to_profile_id = profile.remote_id
        transaction.amount = outlets['value_field'].text.gsub(/[^0-9]/,'').to_f / 100.00
        transaction.transaction_description = outlets['comments_field'].text
        transaction.from_wallet_id = selected_wallet.remote_id
        transaction.rapd_transaction_type = self.transaction_type
        
        transaction_controller = PayRequestSendController.new
        transaction_controller.delegate = self;
        transaction_controller.profile = profile
        transaction_controller.transaction = transaction
        transaction_controller.selected_wallet = selected_wallet
        self.presentModalViewController(transaction_controller, animated: true)
      end
    end

  end
  
  def request_payment
    self.transaction_type = 'deposit_request'
    
    if selected_wallet.blank? 
      self.app_delegate.display_message("Error","Please choose wallet")
    else       
      if outlets['value_field'].text == ""
        self.app_delegate.display_message("Error","Please input valid amount")
      elsif app_delegate.current_profile_id.to_s == profile.remote_id.to_s
        self.app_delegate.display_message("Error","Please select another profile")
      else
        transaction_request = TransactionRequest.new
        transaction_request.from_profile_id = app_delegate.current_profile_id
        transaction_request.to_profile_id = profile.remote_id
        transaction_request.amount = outlets['value_field'].text.gsub(/[^0-9]/,'').to_f / 100.00
        transaction_request.request_description = outlets['comments_field'].text
        transaction_request.currency_id = self.selected_wallet.wallet_type.currency.remote_id
        transaction_request.status = "pending"

        transaction_request_controller = PayRequestReceiveController.new
        transaction_request_controller.delegate = self
        transaction_request_controller.profile = profile
        transaction_request_controller.transaction_request = transaction_request
        transaction_request_controller.selected_wallet = selected_wallet
        self.presentModalViewController(transaction_request_controller, animated: true)
      end
    end
  end
   
  def textFieldDidBeginEditing(textField)
    if textField == self.outlets['profile_selected_field']
      self.navigationController.popViewControllerAnimated(true)
    end
  end
  
  def toggle_wallet
    wallets_controller = WalletsController.new
    wallets_controller.delegate = self
    wallets_controller.profile = current_profile
    
    self.presentModalViewController(wallets_controller, animated: true)
  end
  
end
