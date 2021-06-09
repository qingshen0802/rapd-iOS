class MessageManager < BaseManager

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
    Message
  end

  def key_name
    "message"
  end

  def plural_key_name
    "messages"
  end  

  def request_mapping_hash
    {"from_profile_id" => "from_profile_id",
"to_profile_id" => "to_profile_id",
"messageable_id" => "messageable_id",
"messageable_type" => "messageable_type",
"body" => "body",
"conversation_id" => "conversation_id",
"user_id" => "user_id"}
  end

  def response_mapping_hash
    {"from_profile_id" => "from_profile_id",
"to_profile_id" => "to_profile_id",
"messageable_id" => "messageable_id",
"messageable_type" => "messageable_type",
"body" => "body",
"conversation_id" => "conversation_id",
"user_id" => "user_id",
"id" => "remote_id",
"created_at" => "created_at",
"updated_at" => "updated_at"}
  end

  

end