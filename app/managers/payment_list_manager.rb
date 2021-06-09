class PaymentListManager < BaseManager

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
    PaymentList
  end

  def key_name
    "payment_list"
  end

  def plural_key_name
    "payment_lists"
  end  

  def request_mapping_hash
    {"profile_id" => "profile_id",
"name" => "name",
"list_description" => "list_description",
"is_public" => "is_public",
"expected_amount" => "expected_amount",
"destination_wallet_id" => "destination_wallet_id",
"user_id" => "user_id"}
  end

  def response_mapping_hash
    {"profile_id" => "profile_id",
"name" => "name",
"list_description" => "list_description",
"is_public" => "is_public",
"expected_amount" => "expected_amount",
"destination_wallet_id" => "destination_wallet_id",
"user_id" => "user_id",
"id" => "remote_id",
"created_at" => "created_at",
"updated_at" => "updated_at"}
  end

  

end