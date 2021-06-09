class WalletTypeManager < BaseManager

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
    WalletType
  end

  def key_name
    "wallet_type"
  end

  def plural_key_name
    "wallet_types"
  end  

  def add_nested_response_mappings(mapping)
    currency_mapping = RKObjectMapping.mappingForClass(Currency)
    currency_mapping.addAttributeMappingsFromDictionary(CurrencyManager.shared_manager.response_mapping_hash)
    mapping.addPropertyMapping(RKRelationshipMapping.relationshipMappingFromKeyPath("currency", toKeyPath: "currency", withMapping: currency_mapping))
  end

  def request_mapping_hash
    {
      "name" => "name",
      "withdrawable" => "withdrawable",
      "currency_id" => "currency_id",
      "description" => "description",
      "color" => "color"
    }
  end

  def response_mapping_hash
    {
      "id" => "remote_id",      
      "name" => "name",
      "withdrawable" => "withdrawable",
      "currency_id" => "currency_id",
      "description" => "description",
      "color" => "color",
      "created_at" => "created_at",
      "updated_at" => "updated_at"
    }
  end

end