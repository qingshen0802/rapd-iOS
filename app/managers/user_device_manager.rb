class UserDeviceManager < BaseManager

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
    UserDevice
  end

  def key_name
    "user_device"
  end

  def plural_key_name
    "user_devices"
  end  

  def request_mapping_hash
    {
      "device_type" => "device_type",
      "device_token" => "device_token",
      "user_id" => "user_id"
    }
  end

  def response_mapping_hash
    {
      "device_type" => "device_type",
      "device_token" => "device_token",
      "user_id" => "user_id",
      "id" => "remote_id",
      "created_at" => "created_at",
      "updated_at" => "updated_at"
    }
  end

end
