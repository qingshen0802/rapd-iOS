class ShoppingClubCouponManager < BaseManager

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
    ShoppingClubCoupon
  end

  def key_name
    "shopping_club_coupon"
  end

  def plural_key_name
    "shopping_club_coupons"
  end  

  def request_mapping_hash
    {"profile_id" => "profile_id",
"seller_profile_id" => "seller_profile_id",
"amount" => "amount",
"expires_at" => "expires_at",
"couponable_id" => "couponable_id",
"couponable_type" => "couponable_type",
"status" => "status",
"user_id" => "user_id"}
  end

  def response_mapping_hash
    {"profile_id" => "profile_id",
"seller_profile_id" => "seller_profile_id",
"amount" => "amount",
"expires_at" => "expires_at",
"couponable_id" => "couponable_id",
"couponable_type" => "couponable_type",
"status" => "status",
"user_id" => "user_id",
"id" => "remote_id",
"created_at" => "created_at",
"updated_at" => "updated_at"}
  end

  

end