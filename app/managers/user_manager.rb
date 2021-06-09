class UserManager < BaseManager

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
    User
  end

  def key_name
    "user"
  end

  def plural_key_name
    "users"
  end  

  def request_mapping_hash
    {
      "email" => "email",
      "password" => "password",
      "lat" => "lat",
      "lng" => "lng",
      "phone_number" => "phone_number",
      "facebook_id" => "facebook_id",
      "facebook_token" => "facebook_token",
      "profile_ids" => "profile_ids"
    }
  end

  def response_mapping_hash
    {
      "id" => "remote_id",
      "email" => "email",
      "access_token" => "access_token",
      "phone_number" => "phone_number",
      "sms_confirmed_at" => "sms_confirmed_at",
      "lat" => "lat",
      "lng" => "lng",
      "facebook_id" => "facebook_id",
      "facebook_token" => "facebook_token",
      "profile_ids" => "profile_ids",
      "referral_link" => "referral_link",
      "created_at" => "created_at",
      "updated_at" => "updated_at"
    }
  end

end