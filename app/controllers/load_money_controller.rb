class LoadMoneyController < JsonController

  BRAZILIAN_REAL_ID = 1

  attr_accessor :form_view, :user, :profile, :deposit_amount, :transaction, :currency_ids

  def viewDidLoad
    self.title = "Carregar carteira"
    self.transaction = Transaction.new
        
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

    hide_exchange_components
  end
  
  def picker_view_data
    c = RestClient.new
    self.currency_ids = c.get("#{app_delegate.base_url}/api/currencies/names.json", app_delegate.api_access_token)

    @picker_data ||= {
      "currency_select" => [currency_ids.keys.sort],
      "payment_type_select" => [["Cartão de Crédito", "Boleto Bancário", "Transferência Bancária"]]
    }
    
    self.transaction.currency_short_name = @picker_data["currency_select"].first.first

    @picker_data
  end
  
  def hide_exchange_components
    self.outlets["exchange_square"].hidden = true
    self.outlets["amount_exchange_label"].hidden = true
    self.outlets["today_exchange_label"].hidden = true
  end
  
  def show_exchange_components
    self.outlets["exchange_square"].hidden = false
    self.outlets["amount_exchange_label"].hidden = false
    self.outlets["today_exchange_label"].hidden = false   
  end
  
  def showFees
    c = FeesInformationController.new
    self.presentModalViewController(c, animated: true)
  end
  
  def textFieldDidEndEditing(textField)
    if textField == self.outlets["amount_field"]
      calculate_conversion
    end
  end
  
  def pickerView(pickerView, didSelectRow:row, inComponent:component)
    super(pickerView, didSelectRow:row, inComponent:component)

    if pickerView.outlet == "currency_select"
      value = picker_view_data["currency_select"].first[row]
      
      if value == ""
        self.outlets["currency_select"].text = "R$"
        hide_exchange_components
      elsif value == "R$"
        hide_exchange_components
      else
        calculate_conversion
      end
      
      self.transaction.currency_short_name = value
    end
  end
  
  def calculate_conversion
    amount = self.outlets["amount_field"].text
    
    if amount.present?
      to_short_name = self.outlets["currency_select"].text
      from_currency_id = self.currency_ids[to_short_name]
      to_currency_id   = BRAZILIAN_REAL_ID # Brazilian Real
      
      if from_currency_id != to_currency_id
        show_exchange_components
              
        c = RestClient.new
        path = "#{app_delegate.base_url}/api/currencies/convert.json?buying=1&needs_normalization=1&from_currency_id=#{from_currency_id}&to_currency_id=#{to_currency_id}&amount=#{amount}"

        response = c.get(path, app_delegate.api_access_token)
        self.deposit_amount = "#{to_short_name} #{response["to_amount"]}"
        self.outlets["amount_exchange_label"].text = deposit_amount
      else
        self.deposit_amount = "#{to_short_name} #{self.outlets["amount_field"].text}"
      end
    end
  end
  
  def load_transaction
    case self.outlets["payment_type_select"].text
    when 'Cartão de Crédito'
      self.transaction.transaction_type = 'credit_card'
      self.transaction.should_charge = true
    when 'Boleto Bancário'
      self.transaction.transaction_type = 'bank_installment'
      self.transaction.should_charge = true
    when 'Transferência Bancária'
      self.transaction.transaction_type = 'bank_transfer'
    end
    self.transaction.amount_in_cents = (self.outlets["amount_field"].text.to_f * 100).to_i
    self.transaction.profile_id = self.profile.remote_id
  end
  
  def loadCurrency
    calculate_conversion
    load_transaction
    
    transaction_manager = TransactionManager.shared_manager
    transaction_manager.delegate = self
    transaction_manager.create_resource(transaction)
  end
  
  def resource_created(transaction)
    amount = self.outlets["amount_field"].text
    
    if amount.present?
      self.transaction = transaction
      self.outlets["amount_field"].enabled = false
      self.outlets["currency_select"].enabled = false
      self.outlets["payment_type_select"].enabled = false

      case transaction.transaction_type
      when 'credit_card'
        processCardPayment
      when 'bank_installment'
        showBankInstallmentInfo
      when 'bank_transfer'
        showBankTransferInfo
      end      
    else
      self.app_delegate.display_error("Digite o valor desejado") 
    end
  end
  
  def processCardPayment
    calculate_conversion
    controller = CreditCardsController.new
    controller.profile = profile
    controller.transaction = transaction
    self.navigationController.pushViewController(controller, animated: true)
  end
  
  def showBankInstallmentInfo
    calculate_conversion
    controller = BankInstallmentController.new
    controller.profile = profile
    controller.transaction = transaction
    self.navigationController.pushViewController(controller, animated: true)
  end

  def showBankTransferInfo
    calculate_conversion
    controller = BankTransferController.new
    controller.profile = profile
    controller.transaction = transaction
    self.navigationController.pushViewController(controller, animated: true)
  end

end