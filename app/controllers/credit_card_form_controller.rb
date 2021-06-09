class CreditCardFormController < JsonController

  attr_accessor :form_view, :profile, :credit_card, :addresses, :card_io_view, 
                :card_manager, :credit_cards_controller
  
  def viewDidLoad
    self.addresses = []
    
    self.credit_card = CreditCard.new if credit_card.nil?    
    self.title = credit_card.new_record? ? "Novo Cartão" : "Alterar Cartão"

    self.form_view = FormView.get_form(delegate: self, skip_gesture: true)
    self.view.addSubview(self.form_view)
    self.form_view.place_auto_layout(top: 0, bottom: 0, leading: 0, trailing: 0)
    self.container_view = self.form_view
    self.load_back_button
    title_label = self.load_title

    super
    unless settings[:title_color].nil?
      title_label.textColor = Theme.color(settings[:title_color])
    end
    preload_credit_card_form
  end
  
  def preload_credit_card_form
    unless credit_card.new_record?
      self.outlets["name_field"].text = self.credit_card.name_on_card
      self.outlets["card_number_field"].text = self.credit_card.number
      self.outlets["expiry_date_field"].text = self.credit_card.expiry_date
      self.outlets["cvv_field"].text = self.credit_card.cvv
    end    
  end

  def viewWillAppear(animated)
    super(animated)
    CardIOUtilities.preload
  end

  def item_fetched(profile)
    self.profile = profile
    load_addresses
  end
  
  def load_addresses
    address_manager = AddressManager.shared_manager
    address_manager.delegate = self
    address_manager.fetch_all(profile_id: profile.remote_id)
  end
  
  def items_fetched(addresses)
    self.addresses = addresses
    self.outlets["address_select"].picker_view.reloadData
  end
  
  def address_options
    addresses.map(&:name)
  end
  
  def picker_view_data
    {"address_select" => [address_options]}
  end
  
  def scan_card
    self.card_io_view = CardIOView.alloc.initWithFrame(self.view.frame)
    self.card_io_view.delegate = self
    self.view.addSubview(card_io_view)
  end
  
  def cardIOView(cardIOView, didScanCard:info)
    if (info)
      self.outlets["card_number_field"].text = info.cardNumber
      self.outlets["expiry_date_field"].text = "#{info.expiryMonth}/#{info.expiryYear}" if info.expiryMonth != 0 && info.expiryYear != 0
      self.outlets["cvv_field"].text = info.cvv
    else
      puts "User Cancelled"
    end

    self.card_io_view.removeFromSuperview
  end
  
  def cancelScanCard(sender)
    card_io_view.removeFromSuperview
  end
  
  def save
    self.credit_card.profile_id = profile.remote_id
    self.credit_card.name_on_card = self.outlets["name_field"].text
    self.credit_card.number = self.outlets["card_number_field"].text
    self.credit_card.expiry_date = self.outlets["expiry_date_field"].text
    self.credit_card.cvv = self.outlets["cvv_field"].text
    self.credit_card.autodetect_type
        
    pagarme_card = PagarMeCreditCard.alloc.initWithCardNumber(self.credit_card.number, cardHolderName: self.credit_card.name_on_card, cardExpirationMonth:self.credit_card.expiry_date.split("/").first, cardExpirationYear:self.credit_card.expiry_date.split("/").last, cardCvv:self.credit_card.cvv)
    pagarme_card.delegate = self
    pagarme_card.generateHash
  end
  
  def card_hash_generated(error, card_hash)
    if error
      self.app_delegate.display_error(error)
    else
      self.credit_card.card_hash = card_hash
      finish
    end
  end  
  
  def finish    
    self.card_manager = CreditCardManager.shared_manager
    self.card_manager.delegate = self
    self.show_loading("Carregando...")
    
    if self.credit_card.new_record?
      self.card_manager.create_resource(self.credit_card)
    else
      self.card_manager.update_resource(self.credit_card)
    end
  end

  def resource_created(credit_card)
    self.credit_card = credit_card
    self.dismiss_loading
    self.app_delegate.display_message("Sucesso", "Cartão criado com sucesso")
    self.navigationController.popViewControllerAnimated(true)
    self.credit_cards_controller.load_credit_cards
  end

  def resource_updated(credit_card)
    self.credit_card = credit_card
    self.dismiss_loading
    self.app_delegate.display_message("Sucesso", "Cartão atualizado com sucesso")
    self.navigationController.popViewControllerAnimated(true)
    self.credit_cards_controller.load_credit_cards
  end

end