class WalletManager < BaseManager

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
    Wallet
  end

  def key_name
    "wallet"
  end

  def plural_key_name
    "wallets"
  end  

  def request_mapping_hash
    {
      "wallet_type_id" => "wallet_type_id",
      "profile_id" => "profile_id",
      "user_id" => "user_id",
      "is_default" => "is_default",
      "balance" => "balance"
    }
  end

  def response_mapping_hash
    {
      "id" => "remote_id",      
      "user_id" => "user_id",      
      "wallet_type_id" => "wallet_type_id",
      "profile_id" => "profile_id",
      "balance" => "balance",
      "human_balance" => "human_balance",
      "is_default" => "is_default",
      "created_at" => "created_at",
      "updated_at" => "updated_at"
    }
  end
  
  def add_nested_response_mappings(mapping)
    wallet_type_mapping = RKObjectMapping.mappingForClass(WalletType)
    wallet_type_mapping.addAttributeMappingsFromDictionary(WalletTypeManager.shared_manager.response_mapping_hash)
    WalletTypeManager.shared_manager.add_nested_response_mappings(wallet_type_mapping)
    mapping.addPropertyMapping(RKRelationshipMapping.relationshipMappingFromKeyPath("wallet_type", toKeyPath: "wallet_type", withMapping: wallet_type_mapping))
  end

end