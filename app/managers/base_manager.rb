class BaseManager

  attr_accessor :delegate, :prefix, :current_page

  def app_delegate
    UIApplication.sharedApplication.delegate
  end

  def api_prefix
    "/api"
  end

  def entity_class
    raise "Should be implemented in child class"
  end

  def key_name
    raise "Should be implemented in child class"
  end

  def plural_key_name
    raise "Should be implemented in child class"
  end

  def prepare_mapping(prefix)
    status_codes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)

    request_mapping = get_request_mapping
    response_mapping = get_response_mapping
    
    add_nested_request_mappings(request_mapping)
    add_nested_response_mappings(response_mapping)

    request_descriptor = RKRequestDescriptor.
                            requestDescriptorWithMapping(request_mapping, 
                                                          objectClass: entity_class,
                                                          rootKeyPath: key_name,
                                                          method: RKRequestMethodAny)

    response_descriptor = RKResponseDescriptor.
                            responseDescriptorWithMapping(response_mapping, 
                                                          method: RKRequestMethodAny, 
                                                          pathPattern: "#{api_prefix}#{prefix}#{key_name}.json", 
                                                          keyPath: key_name, 
                                                          statusCodes: status_codes)

    id_response_descriptor = RKResponseDescriptor.
                            responseDescriptorWithMapping(response_mapping, 
                                                          method: RKRequestMethodAny, 
                                                          pathPattern: "#{api_prefix}#{prefix}#{plural_key_name}/:id.json", 
                                                          keyPath: key_name, 
                                                          statusCodes: status_codes)  

    plural_response_descriptor = RKResponseDescriptor.
                            responseDescriptorWithMapping(response_mapping, 
                                                          method: RKRequestMethodAny, 
                                                          pathPattern: "#{api_prefix}#{prefix}#{plural_key_name}.json", 
                                                          keyPath: plural_key_name, 
                                                          statusCodes: status_codes)

    created_response_descriptor = RKResponseDescriptor.
                            responseDescriptorWithMapping(response_mapping, 
                                                          method: RKRequestMethodAny, 
                                                          pathPattern: "#{api_prefix}#{prefix}#{plural_key_name}.json", 
                                                          keyPath: key_name, 
                                                          statusCodes: status_codes)

    rk_manager = RKObjectManager.sharedManager
    rk_manager.addRequestDescriptor(request_descriptor)    
    rk_manager.addResponseDescriptor(response_descriptor)
    rk_manager.addResponseDescriptor(id_response_descriptor)
    rk_manager.addResponseDescriptor(plural_response_descriptor)
    rk_manager.addResponseDescriptor(created_response_descriptor)

    add_extra_mappings(rk_manager, status_codes)
  end   

  def add_extra_mappings(rk_manager, status_codes)
  end

  def add_nested_request_mappings(mapping)
  end

  def add_nested_response_mappings(mapping)
  end

  def get_request_mapping
    mapping = RKObjectMapping.requestMapping
    mapping.addAttributeMappingsFromDictionary(request_mapping_hash)
    mapping
  end

  def get_response_mapping
    mapping = RKObjectMapping.mappingForClass(entity_class)
    mapping.addAttributeMappingsFromDictionary(response_mapping_hash)
    mapping
  end

  def set_api_token(rk_manager)
    rk_manager.HTTPClient.setAuthorizationHeaderWithToken("4p1p455")
  end

  def present_error_message(error, operation)
    if error.domain == NSURLErrorDomain
      app_delegate.display_error(error.localizedDescription)
    else
      data = error.userInfo
      if data["NSLocalizedFailureReason"].nil?
        if data["NSLocalizedRecoverySuggestion"].nil?
          app_delegate.display_error(data["NSLocalizedDescription"])
        else
          error_info = BW::JSON.parse(data["NSLocalizedRecoverySuggestion"])
          app_delegate.display_error(error_info[:message])
        end
      else
        app_delegate.display_error(data["NSLocalizedFailureReason"])
      end
    end
  end

  def rk_manager
    @rk_manager ||= RKObjectManager.sharedManager
  end

  def activate_api_token
    rk_manager.HTTPClient.setAuthorizationHeaderWithToken(app_delegate.api_access_token)
  end

  def activate_user_token
    rk_manager.HTTPClient.setAuthorizationHeaderWithToken(app_delegate.access_token)
  end

  # GET index
  def fetch_all(params = {})
    activate_user_token
    p "#{api_prefix}#{prefix}#{plural_key_name}.json?page=#{current_page || 1}"
    rk_manager.getObjectsAtPath("#{api_prefix}#{prefix}#{plural_key_name}.json?page=#{current_page || 1}", 
                                parameters: params, 
                                success: lambda {|operation, result| 
                                                  items = result.array()
                                                  self.delegate.items_fetched(items) if self.delegate.present?
                                                 },
                                failure: lambda {|operation, error| 
                                                  self.present_error_message(error, operation: operation)})
  end

  def fetch(id, params = {})
    activate_user_token
    params_string = "#{params.map{|k, v| "#{k}=#{v}"}.join("&")}" unless params == {}
    rk_manager.getObjectsAtPath("#{api_prefix}#{prefix}#{plural_key_name}/#{id}.json#{params_string.present? ? "?#{params_string}" : ""}", 
                                parameters: nil, 
                                success: lambda {|operation, result|
                                                  items = result.array()
                                                  self.delegate.item_fetched(items.first) if self.delegate.present?
                                                },
                                failure: lambda {|operation, error| 
                                                  self.present_error_message(error, operation: operation)})
  end

  # POST create
  def create_resource(resource)
    if resource.is_a?(User)
      activate_api_token
    else
      activate_user_token
    end

    rk_manager.postObject(resource, 
                          path: "#{api_prefix}#{prefix}#{plural_key_name}.json", 
                          parameters: nil, 
                          success: lambda{|operation, result|
                                      self.delegate.resource_created(result.array.first) if self.delegate.present?
                                    },
                          failure: lambda{|operation, error|
                            self.delegate.resource_creation_failed if self.delegate.present?
                            self.present_error_message(error, operation: operation)})
  end

  # PATCH UPDATE
  def update_resource(resource)
    activate_user_token
    rk_manager.patchObject(resource, 
                          path: "#{api_prefix}#{prefix}#{plural_key_name}/#{resource.remote_id}.json", 
                          parameters: nil, 
                          success: lambda{|operation, result|
                                      self.delegate.resource_updated(result.array.first) if self.delegate.present?
                                    },
                          failure: lambda{|operation, error|
                            self.delegate.resource_update_failed if self.delegate.present?
                            self.present_error_message(error, operation: operation)})
  end  
  
  def delete_resource(resource)
    activate_user_token
    rk_manager.deleteObject(resource, 
                          path: "#{api_prefix}#{prefix}#{plural_key_name}/#{resource.remote_id}.json", 
                          parameters: nil, 
                          success: lambda{|operation, result|
                                      self.delegate.resource_deleted if self.delegate.present?
                                    },
                          failure: lambda{|operation, error|
                            self.delegate.resource_update_failed if self.delegate.present?
                            self.present_error_message(error, operation: operation)})    
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