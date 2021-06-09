class PrepaidCardRequestManager < BaseManager

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
    PrepaidCardRequest
  end

  def key_name
    "prepaid_card_request"
  end

  def plural_key_name
    "prepaid_card_requests"
  end  

  def request_mapping_hash
    {
      "profile_id"  => "profile_id",
      "address_id"  => "address_id",
      "unlock_pin"  => "unlock_pin",
      "lock_request" => "lock_request",
      "new_request" => "new_request"
    }
  end

  def response_mapping_hash
    {
      "id" => "remote_id",
      "user_id" => "user_id",
      "profile_id" => "profile_id",
      "wallet_id" => "wallet_id",
      "status" => "status",
      "created_at" => "created_at",
      "updated_at" => "updated_at"
    }
  end

end