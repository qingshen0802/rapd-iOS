class AddressbookContactManager < BaseManager

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
    AddressbookContact
  end

  def key_name
    "addressbook_contact"
  end

  def plural_key_name
    "addressbook_contacts"
  end  

  def request_mapping_hash
    {
      "user_id" => "user_id",
      "phone_number" => "phone_number",
      "status" => "status",
    }
  end

  def response_mapping_hash
    {
      "id" => "remote_id", 
      "user_id" => "user_id",           
      "phone_number" => "phone_number",
      "status" => "status",
      "created_at" => "created_at",
      "updated_at" => "updated_at"
    }
  end

  

end