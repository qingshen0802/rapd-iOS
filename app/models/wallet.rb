class Wallet < BaseEntity

  attr_accessor :wallet_type_id, :wallet_type, 
                :profile_id, :user_id, :balance, 
                :human_balance, :is_default

  def short_name
    wallet_type.currency.short_name
  end

end