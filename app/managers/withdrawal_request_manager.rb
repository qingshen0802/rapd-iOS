class WithdrawalRequestManager < BaseManager

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
    WithdrawalRequest
  end

  def key_name
    "withdrawal_request"
  end

  def plural_key_name
    "withdrawal_requests"
  end  

  def request_mapping_hash
    {
      "profile_id" => "profile_id",
      "wallet_id" => "wallet_id",
      "amount" => "amount",
      "bank_account_id" => "bank_account_id",
      "status" => "status",
      "request_description" => "request_description",
      "request_type" => "request_type",
      "prepaid_card_delivery_address" => "prepaid_card_delivery_address",
      "prepaid_card_id" => "prepaid_card_id",
      "user_id" => "user_id"
    }
  end

  def response_mapping_hash
    {
      "id" => "remote_id",
      "user_id" => "user_id",
      "profile_id" => "profile_id",
      "wallet_id" => "wallet_id",
      "exchange_to_default_currency" => "exchange_to_default_currency",
      "amount" => "amount", 
      "human_amount" => "human_amount",
      "bank_account_id" => "bank_account_id",
      "status" => "status",
      "request_description" => "request_description",
      "request_type" => "request_type",
      "prepaid_card_delivery_address" => "prepaid_card_delivery_address",
      "prepaid_card_id" => "prepaid_card_id",
      "created_at" => "created_at",
      "updated_at" => "updated_at"
    }
  end

end