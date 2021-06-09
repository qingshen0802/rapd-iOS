class CurrencyManager < BaseManager

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
    Currency
  end

  def key_name
    "currency"
  end

  def plural_key_name
    "currencies"
  end  

  def request_mapping_hash
    {
      "name" => "name",
      "currency_code" => "currency_code",
      "short_name" => "short_name"
    }
  end

  def response_mapping_hash
    {
      "id" => "remote_id",      
      "name" => "name",
      "currency_code" => "currency_code",
      "short_name" => "short_name",
      "created_at" => "created_at",
      "updated_at" => "updated_at"
    }
  end
end