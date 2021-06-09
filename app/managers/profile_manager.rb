class ProfileManager < BaseManager

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
    Profile
  end

  def key_name
    "profile"
  end

  def plural_key_name
    "profiles"
  end  

  def request_mapping_hash
    {
      "profile_type" => "type",
      "full_name" => "full_name",
      "document_id" => "document_id",
      "email" => "email",
      "photo" => "photo",
      "is_legal_representer" => "is_legal_representer",
      "accepts_terms" => "accepts_terms",
      "is_legal_represented" => "is_legal_represented",
      "legal_representer_name" => "legal_representer_name",
      "legal_representer_document_id" => "legal_representer_document_id",
      "legal_representer_email" => "legal_representer_email",
      "bank_account_id" => "bank_account_id",
      "username" => "username",
      "user_id" => "user_id",
      "birth_date" => "birth_date",
      "facebook_active" => "facebook_active",
      "twitter_active" => "twitter_active",
      "google_plus_active" => "google_plus_active",
      "instagram_active" => "instagram_active",
      "company_category_name" => "company_category_name",
      "push_notifications_active" => "push_notifications_active",
      "automatic_bonus" => "automatic_bonus",
      "touch_id_active" => "touch_id_active",
      "discount_club_active" => "discount_club_active",
      "discount_club_bonus_amount" => "discount_club_bonus_amount",
      "discount_club_bonus_requirement" => "discount_club_bonus_requirement",
      "discount_club_bonus_period" => "discount_club_bonus_period",
      "url" => "url"
    }
  end

  def response_mapping_hash
    {
      "id" => "remote_id",
      "type" => "profile_type",
      "photo" => "photo",
      "photo_url" => "photo_url",
      "cover_photo_url" => "cover_photo_url",
      "full_name" => "full_name",
      "document_id" => "document_id",
      "email" => "email",
      "is_legal_representer" => "is_legal_representer",
      "accepts_terms" => "accepts_terms",
      "is_legal_represented" => "is_legal_represented",
      "legal_representer_name" => "legal_representer_name",
      "legal_representer_document_id" => "legal_representer_document_id",
      "legal_representer_email" => "legal_representer_email",
      "username" => "username",
      "user_id" => "user_id",
      "birth_date" => "birth_date",
      "bank_account_id" => "bank_account_id",
      "current_document_status" => "current_document_status",
      "company_category_name" => "company_category_name",
      "company_category_id" => "company_category_id",    
      "facebook_active" => "facebook_active",
      "twitter_active" => "twitter_active",
      "google_plus_active" => "google_plus_active",
      "instagram_active" => "instagram_active",    
      "referral_link" => "referral_link",
      "push_notifications_active" => "push_notifications_active",
      "touch_id_active" => "touch_id_active",
      "automatic_bonus" => "automatic_bonus",
      "discount_club_active" => "discount_club_active",
      "discount_club_bonus_amount" => "discount_club_bonus_amount",
      "discount_club_bonus_requirement" => "discount_club_bonus_requirement",
      "discount_club_bonus_period" => "discount_club_bonus_period",
      "created_at" => "created_at",
      "updated_at" => "updated_at",
      "distance" => "distance",
      "phone_number" => "phone_number",
      "description" => "description",
      "address" => "address",
      "url" => "url",
      "credits_amount" => "credits_amount"
    }
  end
  
  def create_resource(profile)
    activate_user_token
    
    if profile.any_attachment?
      request = RKObjectManager.sharedManager.multipartFormRequestWithObject(profile, 
                                              method: RKRequestMethodPOST, 
                                              path: "#{api_prefix}#{prefix}profiles.json", 
                                              parameters: nil, 
                                              constructingBodyWithBlock: lambda{|formData|
                                                add_attachment(formData, profile, "photo") if profile.photo.present?
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
      super(profile)
    end
  end  
  
  def update_resource(profile)
    if profile.any_attachment?
      request = RKObjectManager.sharedManager.multipartFormRequestWithObject(profile, 
                                              method: RKRequestMethodPATCH, 
                                              path: "#{api_prefix}#{prefix}profiles/#{profile.remote_id.to_s}.json", 
                                              parameters: nil, 
                                              constructingBodyWithBlock: lambda{|formData|
                                                #add_attachment(formData, profile, "photo") if profile.photo.present?
                                              })
      operation = RKObjectManager.sharedManager.objectRequestOperationWithRequest(request, 
                            success: lambda{|operation, result|
                              p 'update_success'
                              self.delegate.resource_updated(result.array.first) if self.delegate.present?
                            },
                            failure: lambda{|operation, error|
                              p 'update_failure'
                              self.delegate.resource_update_failed if self.delegate.present?
                              self.present_error_message(error, operation: operation)
                            })
      RKObjectManager.sharedManager.enqueueObjectRequestOperation(operation)
    else
      super(profile)
    end
  end

  def add_attachment(formData, entity, field_name)
    case entity.send("#{field_name}_mime_type")
    when 'image/jpeg'
      p 'image/jpeg'
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