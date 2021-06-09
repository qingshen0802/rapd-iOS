class YearlyReportManager < BaseManager
  
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
    YearlyReport
  end

  def key_name
    "yearly_report"
  end

  def plural_key_name
    "yearly_reports"
  end  

  def add_nested_response_mappings(mapping)
    transactions_mapping = RKObjectMapping.mappingForClass(RapdTransaction)
    transactions_mapping.addAttributeMappingsFromDictionary(RapdTransactionManager.shared_manager.response_mapping_hash)
    mapping.addPropertyMapping(RKRelationshipMapping.relationshipMappingFromKeyPath("rapd_transactions", toKeyPath: "rapd_transactions", withMapping: transactions_mapping))
  end

  def request_mapping_hash
    {}
  end

  def response_mapping_hash
    {
      "year" => "year",
      "months" => "months",
      "current_balance" => "current_balance"
    }
  end    
  
end