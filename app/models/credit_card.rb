class CreditCard < BaseEntity

  attr_accessor :address_id, :profile_id, :card_type, :name_on_card, :card_hash, 
                :last_four_digits, :user_id, :is_default_card, :make_default, 
                :remove_default, :number, :cvv, :expiry_date

  def autodetect_type
    result = "unknown"
    
    if number =~ /^5[1-5]/
      result = 'master_card'
    elsif number =~ /^4/
      result = 'visa'
    elsif number =~ /^3[47]/
      result = 'amex'
    end
    
    self.card_type = result
  end

end