class TransactionManager < BaseManager

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
    Transaction
  end

  def key_name
    "transaction"
  end

  def plural_key_name
    "transactions"
  end  

  def request_mapping_hash
    {
      "amount_in_cents" => "amount_in_cents",
      "user_id" => "user_id",
      "attachment" => "attachment",
      "attachment_url" => "attachment_url",
      "attachment_mime_type" => "attachment_mime_type",
      "transaction_type" => "transaction_type",
      "transactionable_id" => "transactionable_id",
      "transactionable_type" => "transactionable_type",
      "credit_card_id" => "credit_card_id",
      "profile_id" => "profile_id",
      "should_charge" => "should_charge",
      "currency_short_name" => "currency_short_name"
    }
  end

  def response_mapping_hash
    {
      "id" => "remote_id",
      "attachment" => "attachment",
      "attachment_url" => "attachment_url", 
      "transaction_type" => "transaction_type", 
      "status" => "status",
      "stripe_data" => "stripe_data",
      "stripe_token" => "stripe_token",
      "amount_in_cents" => "amount_in_cents",
      "human_amount" => "human_amount",
      "user_id" => "user_id",
      "transactionable_id" => "transactionable_id",
      "transactionable_type" => "transactionable_type",
      "profile_id" => "profile_id",
      "attachment_mime_type" => "attachment_mime_type",
      "expires_at" => "expires_at",
      "bank_installment_code" => "bank_installment_code", 
      "bank_installment_url" => "bank_installment_url", 
      "created_at" => "created_at",
      "updated_at" => "updated_at"
    }
  end

  def add_nested_response_mappings(mapping)
    card_mapping = RKObjectMapping.mappingForClass(CreditCard)
    card_mapping.addAttributeMappingsFromDictionary(CreditCardManager.shared_manager.response_mapping_hash)
    mapping.addPropertyMapping(RKRelationshipMapping.relationshipMappingFromKeyPath("credit_card", toKeyPath: "credit_card", withMapping: card_mapping))
        
    wallet_mapping = RKObjectMapping.mappingForClass(Wallet)
    wallet_mapping.addAttributeMappingsFromDictionary(WalletManager.shared_manager.response_mapping_hash)
    WalletManager.shared_manager.add_nested_response_mappings(wallet_mapping)
    mapping.addPropertyMapping(RKRelationshipMapping.relationshipMappingFromKeyPath("wallet", toKeyPath: "wallet", withMapping: wallet_mapping))

    rapd_transaction_mapping = RKObjectMapping.mappingForClass(RapdTransaction)
    rapd_transaction_mapping.addAttributeMappingsFromDictionary(RapdTransactionManager.shared_manager.response_mapping_hash)
    RapdTransactionManager.shared_manager.add_nested_response_mappings(rapd_transaction_mapping)
    mapping.addPropertyMapping(RKRelationshipMapping.relationshipMappingFromKeyPath("deposit_transaction", toKeyPath: "deposit_transaction", withMapping: rapd_transaction_mapping))
  end

  def create_resource(transaction)
    activate_user_token
    
    if transaction.any_attachment?
      request = RKObjectManager.sharedManager.multipartFormRequestWithObject(transaction, 
                                              method: RKRequestMethodPOST, 
                                              path: "#{api_prefix}#{prefix}transactions.json", 
                                              parameters: nil, 
                                              constructingBodyWithBlock: lambda{|formData|
                                                add_attachment(formData, transaction, "attachment") if transaction.attachment.present?
                                              })
      operation = RKObjectManager.sharedManager.objectRequestOperationWithRequest(request, 
                            success: lambda{|operation, result|
                              self.delegate.resource_created(result.array.first) if self.delegate.present?
                            },
                            failure: lambda{|operation, error|
                              self.delegate.resource_creation_failed if self.delegate.present?
                              self.present_error_message(error, operation: operation)
                            })
      RKObjectManager.sharedManager.enqueueObjectRequestOperation(operation)
    else
      super(transaction)
    end
  end  
  
  def update_resource(transaction)
    if transaction.any_attachment?
      request = RKObjectManager.sharedManager.multipartFormRequestWithObject(transaction, 
                                              method: RKRequestMethodPATCH, 
                                              path: "#{api_prefix}#{prefix}transactions/#{transaction.remote_id.to_s}.json", 
                                              parameters: nil, 
                                              constructingBodyWithBlock: lambda{|formData|
                                                add_attachment(formData, transaction, "attachment") if transaction.attachment.present?
                                              })
      operation = RKObjectManager.sharedManager.objectRequestOperationWithRequest(request, 
                            success: lambda{|operation, result|
                              self.delegate.resource_updated(result.array.first) if self.delegate.present?
                            },
                            failure: lambda{|operation, error|
                              self.delegate.resource_update_failed if self.delegate.present?
                              self.present_error_message(error, operation: operation)
                            })
      RKObjectManager.sharedManager.enqueueObjectRequestOperation(operation)
    else
      super(transaction)
    end
  end

end