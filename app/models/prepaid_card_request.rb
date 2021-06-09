class PrepaidCardRequest < BaseEntity

  attr_accessor :profile_id, :wallet_id, :status, :address_id, :user_id, 
                :prepaid_card, :unlock_pin, :lock_request, :new_request

end