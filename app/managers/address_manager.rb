class AddressManager < BaseManager

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
    Address
  end

  def key_name
    "address"
  end

  def plural_key_name
    "addresses"
  end  

  def request_mapping_hash
    {
      "name" => "name",
      "address_line_1" => "address_line_1",
      "address_line_2" => "address_line_2",
      "address_line_3" => "address_line_3",
      "borough" => "borough",
      "city" => "city",
      "state" => "state",
      "postal_code" => "postal_code",
      "profile_id" => "profile_id",
      "default_address" => "default_address",
      "user_id" => "user_id"
    }
  end

  def response_mapping_hash
    {
      "name" => "name",
      "address_line_1" => "address_line_1",
      "address_line_2" => "address_line_2",
      "address_line_3" => "address_line_3",
      "borough" => "borough",
      "city" => "city",
      "state" => "state",
      "postal_code" => "postal_code",
      "profile_id" => "profile_id",
      "user_id" => "user_id",
      "id" => "remote_id",
      "default_address" => "default_address",
      "created_at" => "created_at",
      "updated_at" => "updated_at"
    }
  end  

end