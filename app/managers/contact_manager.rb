class ContactManager < BaseManager

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
    Contact
  end

  def key_name
    "contact"
  end

  def plural_key_name
    "contacts"
  end  

  def add_nested_response_mappings(mapping)
    contact_mapping = RKObjectMapping.mappingForClass(Profile)
    contact_mapping.addAttributeMappingsFromDictionary(ProfileManager.shared_manager.response_mapping_hash)
    mapping.addPropertyMapping(RKRelationshipMapping.relationshipMappingFromKeyPath("contact", toKeyPath: "contact", withMapping: contact_mapping))
  end

  def request_mapping_hash
    {
      "user_id" => "user_id",      
      "profile_id" => "profile_id",
      "contact_id" => "contact_id",
      "is_employee" => "is_employee"
    }
  end

  def response_mapping_hash
    {
      "id" => "remote_id",      
      "user_id" => "user_id",      
      "profile_id" => "profile_id",
      "contact_id" => "contact_id",
      "is_employee" => "is_employee",
      "created_at" => "created_at",
      "updated_at" => "updated_at"
    }
  end

end