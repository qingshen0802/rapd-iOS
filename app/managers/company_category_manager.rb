class CompanyCategoryManager < BaseManager

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
    CompanyCategory
  end

  def key_name
    "company_category"
  end

  def plural_key_name
    "company_categories"
  end  

  def request_mapping_hash
    {"name" => "name"}
  end

  def response_mapping_hash
    {"name" => "name",
    "id" => "remote_id",
    "created_at" => "created_at",
    "updated_at" => "updated_at"}
  end

  

end