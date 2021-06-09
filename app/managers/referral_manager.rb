class ReferralManager < BaseManager

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
    Referral
  end

  def key_name
    "referral"
  end

  def plural_key_name
    "referrals"
  end  
  
  def add_nested_response_mappings(mapping)
    referred_mapping = RKObjectMapping.mappingForClass(Profile)
    referred_mapping.addAttributeMappingsFromDictionary(ProfileManager.shared_manager.response_mapping_hash)
    mapping.addPropertyMapping(RKRelationshipMapping.relationshipMappingFromKeyPath("referred", toKeyPath: "referred", withMapping: referred_mapping))
  end    

  def request_mapping_hash
    {
      "referrer_id" => "referrer_id",
      "referred_id" => "referred_id"
    }
  end

  def response_mapping_hash
    {
      "id" => "remote_id",
      "referrer_id" => "referrer_id",
      "referred_id" => "referred_id",
      "created_at" => "created_at",
      "updated_at" => "updated_at"
    }
  end

end