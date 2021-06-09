class TransactionRequestManager < BaseManager

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
    TransactionRequest
  end

  def key_name
    "transaction_request"
  end

  def plural_key_name
    "transaction_requests"
  end  

  def add_nested_response_mappings(mapping)
    profile_mapping = RKObjectMapping.mappingForClass(Profile)
    profile_mapping.addAttributeMappingsFromDictionary(ProfileManager.shared_manager.response_mapping_hash)
    mapping.addPropertyMapping(RKRelationshipMapping.relationshipMappingFromKeyPath("to_profile", toKeyPath: "to_profile", withMapping: profile_mapping))
  end

  def request_mapping_hash
    {
      "user_id" => "user_id",
      "currency_id" => "currency_id",
      "from_profile_id" => "from_profile_id",
      "to_profile_id" => "to_profile_id",
      "amount" => "amount",
      "request_description" => "request_description",
      "rapd_transaction_id" => "rapd_transaction_id",
      "status" => "status"
    }
  end

  def response_mapping_hash
    {
      "id" => "remote_id",      
      "user_id" => "user_id",
      "currency_id" => "currency_id",      
      "from_profile_id" => "from_profile_id",
      "to_profile_id" => "to_profile_id",
      "amount" => "amount",
      "human_amount" => "human_amount",
      "status" => "status",
      "request_description" => "request_description",
      "rapd_transaction_id" => "rapd_transaction_id",
      "created_at" => "created_at",
      "updated_at" => "updated_at"
    }
  end

end