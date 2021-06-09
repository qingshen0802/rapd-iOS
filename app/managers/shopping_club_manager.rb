class ShoppingClubManager < BaseManager

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
    ShoppingClub
  end

  def key_name
    "shopping_club"
  end

  def plural_key_name
    "shopping_clubs"
  end  

  def request_mapping_hash
    {"profile_id" => "profile_id",
"coupon_amount" => "coupon_amount",
"activation_amount" => "activation_amount",
"expiration_in_days" => "expiration_in_days",
"has_automatic_coupons" => "has_automatic_coupons",
"user_id" => "user_id"}
  end

  def response_mapping_hash
    {"profile_id" => "profile_id",
"coupon_amount" => "coupon_amount",
"activation_amount" => "activation_amount",
"expiration_in_days" => "expiration_in_days",
"has_automatic_coupons" => "has_automatic_coupons",
"user_id" => "user_id",
"id" => "remote_id",
"created_at" => "created_at",
"updated_at" => "updated_at"}
  end

  

end