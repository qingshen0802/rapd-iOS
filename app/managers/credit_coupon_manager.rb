class CreditCouponManager < BaseManager

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
    CreditCoupon
  end

  def key_name
    "credit_coupon"
  end

  def plural_key_name
    "credit_coupons"
  end  

  def request_mapping_hash
    {"profile_id" => "profile_id",
"coupon_code" => "coupon_code",
"amount" => "amount",
"expires_at" => "expires_at",
"coupon_description" => "coupon_description",
"user_id" => "user_id"}
  end

  def response_mapping_hash
    {"profile_id" => "profile_id",
"coupon_code" => "coupon_code",
"amount" => "amount",
"expires_at" => "expires_at",
"coupon_description" => "coupon_description",
"user_id" => "user_id",
"id" => "remote_id",
"created_at" => "created_at",
"updated_at" => "updated_at"}
  end

  

end