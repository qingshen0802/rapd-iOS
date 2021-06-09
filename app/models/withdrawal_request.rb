class WithdrawalRequest < BaseEntity

  attr_accessor :profile_id, :wallet_id, :amount, :bank_account_id, :status, 
                :request_description,  :request_type, :prepaid_card_delivery_address, 
                :prepaid_card_id, :user_id, :human_amount, :exchange_to_default_currency

end