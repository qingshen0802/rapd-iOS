class RapdTransaction < BaseEntity

  attr_accessor :from_profile_id, :to_profile_id, :amount, :transaction_description, 
                :from_wallet_id, :to_wallet_id, :transaction_code, :transaction_id, 
                :location, :rapd_transaction_type, :user_id, :human_amount, :from_profile,
                :to_profile, :from_wallet, :to_wallet, :human_timestamp, :wallet_id, :wallet

end