class PrepaidCardManager < BaseManager

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
    PrepaidCard
  end

  def key_name
    "prepaid_card"
  end

  def plural_key_name
    "prepaid_cards"
  end  

  def request_mapping_hash
    {
      "profile_id" => "profile_id",
      "amount" => "amount",
      "status" => "status",
      "account_number" => "account_number",
      "prepaid_card_request_id" => "prepaid_card_request_id",
      "user_id" => "user_id"
    }
  end

  def response_mapping_hash
    {
      "id" => "remote_id",
      "user_id" => "user_id",      
      "profile_id" => "profile_id",
      "prepaid_card_request_id" => "prepaid_card_request_id",
      "amount" => "amount",
      "status" => "status",
      "account_number" => "account_number",      
      "created_at" => "created_at",
      "updated_at" => "updated_at"
    }
  end

  def add_nested_response_mappings(mapping)
    prepaid_card_mapping = RKObjectMapping.mappingForClass(PrepaidCard)
    prepaid_card_mapping.addAttributeMappingsFromDictionary(PrepaidCardManager.shared_manager.response_mapping_hash)
    PrepaidCardManager.shared_manager.add_nested_response_mappings(prepaid_card_mapping)
    mapping.addPropertyMapping(RKRelationshipMapping.relationshipMappingFromKeyPath("prepaid_card", toKeyPath: "prepaid_card", withMapping: prepaid_card_mapping))
  end
  
end