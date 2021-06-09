class NotificationManager < BaseManager

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
    Notification
  end

  def key_name
    "notification"
  end

  def plural_key_name
    "notifications"
  end  

  def request_mapping_hash
    {
      "profile_id" => "profile_id"
    }
  end

  def response_mapping_hash
    {
      "id" => "remote_id",
      "type" => "type",
      "notifiable_id" => "notifiable_id",
      "user_id" => "user_id",
      "profile_id" => "profile_id",
      "title" => "title",
      "description" => "description",
      "read" => "read",
      "importance" => "importance",
      "created_at" => "created_at",
      "updated_at" => "updated_at",
      "color" => "color",
      "from_user_photo_url" => "from_user_photo_url",
      "from_user_name" => "from_user_name",
      "to_user_photo_url" => "to_user_photo_url",
      "to_user_name" => "to_user_name"
    }
  end

end
