class CreditCardManager < BaseManager

  cattr_accessor :manager

  def self.shared_manager
    if @@manager.nil?
      @@manager = new
      @@manager.prefix = "/"
      @@manager.prepare_mapping(@@manager.prefix)
    end
    @@manager
  end

  def entity_class
    CreditCard
  end

  def key_name
    "credit_card"
  end

  def plural_key_name
    "credit_cards"
  end  

  def request_mapping_hash
    {
      "address_id" => "address_id",
      "profile_id" => "profile_id",
      "card_type" => "card_type",
      "name_on_card" => "name_on_card",
      "number" => "number",
      "cvv" => "cvv",
      "expiry_date" => "expiry_date",
      "card_hash" => "card_hash",
      "last_four_digits" => "last_four_digits",
      "user_id" => "user_id",
      "make_default" => "make_default",
      "remove_default" => "remove_default"
    }
  end

  def response_mapping_hash
    {
      "id" => "remote_id",      
      "user_id" => "user_id",
      "profile_id" => "profile_id",      
      "address_id" => "address_id",
      "profile_id" => "profile_id",
      "card_type" => "card_type",
      "name_on_card" => "name_on_card",
      "card_hash" => "card_hash",
      "last_four_digits" => "last_four_digits",
      "is_default_card" => "is_default_card",
      "created_at" => "created_at",
      "updated_at" => "updated_at"
    }
  end

end