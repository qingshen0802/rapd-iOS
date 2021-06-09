class FavoriteManager < BaseManager

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
    Favorite
  end

  def key_name
    "favorite"
  end

  def plural_key_name
    "favorites"
  end
  
  def add_nested_response_mappings(mapping)
    favorited_mapping = RKObjectMapping.mappingForClass(Profile)
    favorited_mapping.addAttributeMappingsFromDictionary(ProfileManager.shared_manager.response_mapping_hash)
    mapping.addPropertyMapping(RKRelationshipMapping.relationshipMappingFromKeyPath("favorited", toKeyPath: "favorited", withMapping: favorited_mapping))
  end

  def request_mapping_hash
    {
      "favorited_id" => "favorited_id",
      "profile_id" => "profile_id",
      "user_id" => "user_id"
    }
  end

  def response_mapping_hash
    {
      "favorited_id" => "favorited_id",
      "profile_id" => "profile_id",
      "user_id" => "user_id",
      "id" => "remote_id",
      "created_at" => "created_at",
      "updated_at" => "updated_at"
    }
  end

  

end