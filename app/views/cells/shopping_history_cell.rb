class ShoppingHistoryCell < BaseCell
  
  attr_accessor :report, :transaction
  
  def set_data(data = {})
    super(data)
    self.report = data[:report]
    self.transaction = data[:transaction]

    self.outlets["title_label"].text = title_for_transaction
    self.outlets["description_label"].text = subtitle_for_transaction
    if transaction.deposit_transaction.present?
      self.outlets["amount_label"].text = "#{transaction.deposit_transaction.wallet.wallet_type.currency.short_name} #{transaction.deposit_transaction.human_amount}"
    else
      self.outlets["amount_label"].text = "#{transaction.wallet.wallet_type.currency.short_name} #{transaction.human_amount}"
    end
    self.outlets["amount_label"].textColor = Theme.color(color_for_status(transaction.status))
  end
  
  def color_for_status(status)
    case status
    when 'declined'
      "d9242b"
    when 'on_hold'
      "d9242b"
    when 'pending'
      "f7b33e"
    when 'approved'
      "48bf81"
    end
  end
  
  def title_for_transaction
    case transaction.transaction_type
    when 'credit_card'
      if transaction.deposit_transaction.blank? || transaction.deposit_transaction.wallet.wallet_type.currency.short_name == "R$"
        "Compra com cartão"
      else
        "Comnpra com cartão em #{transaction.deposit_transaction.wallet.wallet_type.currency.name}"
      end
    when 'bank_installment'
      status_for_transaction
    when 'bank_transfer'
      status_for_transaction
    end
  end
  
  def subtitle_for_transaction
    case transaction.transaction_type
    when 'credit_card'
      "Final ##{transaction.credit_card.last_four_digits}"
    when 'bank_installment'
      "Boleto"
    when 'bank_transfer'
      "Transferência Bancária"
    end
  end
  
  def status_for_transaction
    case transaction.status
    when 'declined'
      "Pagamento Negado / Cancelado"
    when 'on_hold'
      "Pagamento em Análise"
    when 'pending'
      "Aguardando Pagamento"
    when 'approved'
      "Pagamento Aprovado"
    end
  end
  
end