class ConversionRequestManager < BaseManager

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
    ConversionRequest
  end

  def key_name
    "conversion_request"
  end

  def plural_key_name
    "conversion_requests"
  end  

  def request_mapping_hash
    {
      "profile_id" => "profile_id",
      "from_currency_id" => "from_currency_id",
      "to_currency_id" => "to_currency_id",
      "from_amount" => "from_amount",
      "to_amount" => "to_amount",
      "user_id" => "user_id"
    }
  end

  def response_mapping_hash
    {
      "id" => "remote_id",
      "user_id" => "user_id",
      "profile_id" => "profile_id",
      "from_wallet_id" => "from_wallet_id",
      "to_wallet_id" => "to_wallet_id",
      "from_amount" => "from_amount",
      "to_amount" => "to_amount",
      "created_at" => "created_at",
      "updated_at" => "updated_at"
    }
  end

end