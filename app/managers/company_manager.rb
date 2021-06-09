class CompanyManager < ProfileManager

  attr_accessor :manager


  def self.shared_manager
    if @@manager.nil?
      @@manager = new
      @@manager.prefix = "/"
      @@manager.prepare_mapping(@@manager.prefix)
    end
    
    @@manager
  end

  def entity_class
    Company
  end

  def key_name
    "company"
  end

  def plural_key_name
    "companies"
  end

end