class PaymentListParticipantManager < BaseManager

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
    PaymentListParticipant
  end

  def key_name
    "payment_list_participant"
  end

  def plural_key_name
    "payment_list_participants"
  end  

  def request_mapping_hash
    {"payment_list_id" => "payment_list_id",
"profile_id" => "profile_id",
"expected_amount" => "expected_amount",
"payment_status" => "payment_status"}
  end

  def response_mapping_hash
    {"payment_list_id" => "payment_list_id",
"profile_id" => "profile_id",
"expected_amount" => "expected_amount",
"payment_status" => "payment_status",
"id" => "remote_id",
"created_at" => "created_at",
"updated_at" => "updated_at"}
  end

  

end