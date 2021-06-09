class Transaction < BaseEntity

  attr_accessor :status, :stripe_data, :stripe_token, :amount_in_cents, :user_id, 
                :transactionable_id, :transactionable_type, :profile_id, :attachment, 
                :attachment_url, :transaction_type, :attachment_mime_type, :expires_at,
                :bank_installment_code, :bank_installment_url, :should_charge, :credit_card_id,
                :wallet_id, :currency_short_name, :human_amount, :deposit_transaction, :wallet,
                :credit_card

  def any_attachment?
    [attachment].map(&:present?).include?(true)
  end

  def readable_amount
    "R$ #{amount_in_cents.to_f / 100.0}"
  end
  
  def approved?
    self.status == 'approved'
  end

end