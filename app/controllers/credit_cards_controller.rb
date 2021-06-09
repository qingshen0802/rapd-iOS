class CreditCardsController < JsonController

  attr_accessor :credit_cards, :profile, :transaction, :credit_card_manager
  
  def viewDidLoad
    self.title = "Cartões de crédito"
    super
    load_credit_cards
    back_button = self.load_back_button
    title_label = self.load_title    
    unless settings[:title_color].nil?
      title_label.textColor = Theme.color(settings[:title_color])
    end
  end
  
  def noContentLabelColor
    UIColor.whiteColor
  end
  
  def load_credit_cards
    self.credit_card_manager = CreditCardManager.shared_manager
    self.credit_card_manager.delegate = self
    self.credit_card_manager.fetch_all(profile_id: profile.remote_id)
  end
  
  def items_fetched(credit_cards)
    self.credit_cards = credit_cards
    self.data_table_view.reloadData
  end
  
  def credit_card_rows
    credit_cards.map{|credit_card|
      {cell_type: "credit_card", action: "select_credit_card", action_param: credit_card, card_created_text: "Criado em #{credit_card.created_at}", card_number: "XXXX XXXX XXXX #{credit_card.last_four_digits}", card_logo: "images/#{credit_card.card_type}_logo.png", is_default_card: credit_card.is_default_card}
    }
  end
  
  def table_data
    if self.credit_cards.nil? || self.credit_cards.to_a.count == 0
      []
    else
      [{rows: credit_card_rows}]
    end
  end
  
  def select_credit_card(credit_card)
    if transaction.present?
      transaction.credit_card_id = credit_card.remote_id
      
      transaction_manager = TransactionManager.shared_manager
      transaction_manager.delegate = self
      transaction_manager.update_resource(transaction)
    end
  end
  
  def processed_transaction(transaction)
    controller = TransactionStatusController.new
    controller.profile = profile
    controller.transaction = transaction
    self.navigationController.pushViewController(controller, animated: true)
  end
  
  
  def addCard
    controller = CreditCardFormController.new
    controller.profile = profile
    controller.credit_cards_controller = self
    self.navigationController.pushViewController(controller, animated: true)
  end
  
  def creditCardForCell(cell)
    index_path = self.data_table_view.indexPathForCell(cell)
    self.credit_cards[index_path.row]    
  end
  
  def markCardAsDefault(switch)
    credit_card = creditCardForCell(switch.superview.superview)
    
    if switch.isOn
      credit_card.make_default = true
    else
      credit_card.remove_default = true
    end
    
    credit_card_manager.update_resource(credit_card)
  end
  
  def resource_updated(resource)
    if resource.is_a?(Transaction)
      processed_transaction(resource)
    elsif resource.is_a?(CreditCard)
      load_credit_cards      
    end
  end
  
  def manageCreditCard(button)
    credit_card = creditCardForCell(button.superview.superview)
    
    c = ManageCreditCardController.new
    c.credit_card = credit_card
    c.credit_cards_controller = self
    self.navigationController.pushViewController(c, animated: true)
  end

end