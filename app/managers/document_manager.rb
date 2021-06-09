class DocumentManager < BaseManager

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
    Document
  end

  def key_name
    "document"
  end

  def plural_key_name
    "documents"
  end  

  def request_mapping_hash
    {
      "position" => "position",
      "attachment" => "attachment",
      "document_description" => "document_description",
      "profile_id" => "profile_id",
      "approval_status" => "approval_status",
      "user_id" => "user_id"
    }
  end

  def response_mapping_hash
    {
      "id" => "remote_id",      
      "position" => "position",
      "attachment" => "attachment",
      "attachment_url" => "attachment_url",      
      "document_description" => "document_description",
      "profile_id" => "profile_id",
      "approval_status" => "approval_status",
      "user_id" => "user_id",
      "created_at" => "created_at",
      "updated_at" => "updated_at"
    }
  end

  
  def create_resource(document)
    activate_user_token
    
    if document.any_attachment?
      request = RKObjectManager.sharedManager.multipartFormRequestWithObject(document, 
                                                method: RKRequestMethodPOST, 
                                                path: "#{api_prefix}#{prefix}documents.json", 
                                                parameters: nil, 
                                                constructingBodyWithBlock: lambda{|formData|
                                                  
                                                  add_attachment(formData, document, "attachment") if document.attachment.present?
                                                  
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
      super(document)
    end
  end  

  
  def update_resource(document)
    if document.any_attachment?
      request = RKObjectManager.sharedManager.multipartFormRequestWithObject(document, 
                                              method: RKRequestMethodPATCH, 
                                              path: "#{api_prefix}#{prefix}documents/#{document.remote_id.to_s}.json", 
                                              parameters: nil, 
                                              constructingBodyWithBlock: lambda{|formData|
                                                
                                                add_attachment(formData, document, "attachment") if document.attachment.present?
                                                
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
      super(document)
    end
  end

  def add_attachment(formData, entity, field_name)
    case entity.send("#{field_name}_mime_type")
    when 'image/jpeg'
      formData.appendPartWithFileData(UIImageJPEGRepresentation(entity.send(field_name), 1.0), 
                                      name: "#{entity.class.to_s.underscore}[#{field_name}]", 
                                      fileName: "#{field_name}.jpg", 
                                      mimeType: "image/jpeg")          
    when 'image/png'
      formData.appendPartWithFileData(UIImagePNGRepresentation(entity.send(field_name)), 
                                      name: "#{entity.class.to_s.underscore}[#{field_name}]", 
                                      fileName: "#{field_name}.png", 
                                      mimeType: "image/png")
    else
    end
  end  
  

end