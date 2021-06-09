class ConversationManager < BaseManager

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
    Conversation
  end

  def key_name
    "conversation"
  end

  def plural_key_name
    "conversations"
  end  

  def request_mapping_hash
    {"participant_ids" => "participant_ids"}
  end

  def response_mapping_hash
    {"participant_ids" => "participant_ids",
"id" => "remote_id",
"created_at" => "created_at",
"updated_at" => "updated_at"}
  end

  

end