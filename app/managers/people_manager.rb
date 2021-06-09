class PeopleManager < BaseManager

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
    People
  end

  def key_name
    "people"
  end

  def plural_key_name
    "people"
  end  

  def request_mapping_hash
    {
    }
  end

  def response_mapping_hash
    {
      "id" => "remote_id",
      "full_name" => "full_name",
      "type" => "type",
      "username" => "username",
      "photo_url" => "photo_url",
      "cover_photo_url" => "cover_photo_url",
      "company_category_name" => "company_category_name",
      "referral_link" => "referral_link",
      "address" => "address",
      "credits_amount" => "credits_amount",
      "phone_number" => "phone_number",
      "latitude" => "latitude",
      "longitude" => "longitude",
      "description" => "description",
      "url" => "url",
      "discount_club_active" => "discount_club_active",
      "discount_club_bonus_amount" => "discount_club_bonus_amount"
    }
  end

end