class RapdTransactionManager < BaseManager

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
    RapdTransaction
  end

  def key_name
    "rapd_transaction"
  end

  def plural_key_name
    "rapd_transactions"
  end  

  def add_nested_response_mappings(mapping)
    to_profile_mapping = RKObjectMapping.mappingForClass(Profile)
    to_profile_mapping.addAttributeMappingsFromDictionary(ProfileManager.shared_manager.response_mapping_hash)
    mapping.addPropertyMapping(RKRelationshipMapping.relationshipMappingFromKeyPath("to_profile", toKeyPath: "to_profile", withMapping: to_profile_mapping))
    
    from_profile_mapping = RKObjectMapping.mappingForClass(Profile)
    from_profile_mapping.addAttributeMappingsFromDictionary(ProfileManager.shared_manager.response_mapping_hash)
    mapping.addPropertyMapping(RKRelationshipMapping.relationshipMappingFromKeyPath("from_profile", toKeyPath: "from_profile", withMapping: from_profile_mapping))    
    
    wallet_mapping = RKObjectMapping.mappingForClass(Wallet)
    wallet_mapping.addAttributeMappingsFromDictionary(WalletManager.shared_manager.response_mapping_hash)
    WalletManager.shared_manager.add_nested_response_mappings(wallet_mapping)
    mapping.addPropertyMapping(RKRelationshipMapping.relationshipMappingFromKeyPath("wallet", toKeyPath: "wallet", withMapping: wallet_mapping))
  end

  def request_mapping_hash
    {
      "from_profile_id" => "from_profile_id",
      "to_profile_id" => "to_profile_id",
      "amount" => "amount",
      "human_amount" => "human_amount",
      "transaction_description" => "transaction_description",
      "from_wallet_id" => "from_wallet_id",
      "to_wallet_id" => "to_wallet_id",
      "transaction_code" => "transaction_code",
      "transaction_id" => "transaction_id",
      "location" => "location",
      "rapd_transaction_type" => "rapd_transaction_type",
      "user_id" => "user_id"
    }
  end

  def response_mapping_hash
    {
      "id" => "remote_id",      
      "user_id" => "user_id",      
      "from_profile_id" => "from_profile_id",
      "to_profile_id" => "to_profile_id",
      "amount" => "amount",
      "human_amount" => "human_amount",
      "transaction_description" => "transaction_description",
      "from_wallet_id" => "from_wallet_id",
      "to_wallet_id" => "to_wallet_id",
      "transaction_code" => "transaction_code",
      "transaction_id" => "transaction_id",
      "location" => "location",
      "rapd_transaction_type" => "rapd_transaction_type",
      "human_timestamp" => "human_timestamp",
      "created_at" => "created_at",
      "updated_at" => "updated_at"
    }
  end

  

end