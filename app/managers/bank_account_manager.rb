class BankAccountManager < BaseManager

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
    BankAccount
  end

  def key_name
    "bank_account"
  end

  def plural_key_name
    "bank_accounts"
  end  

  def request_mapping_hash
    {
      "bank_name" => "bank_name",
      "branch_number" => "branch_number",
      "branch_digit" => "branch_digit",
      "account_number" => "account_number",
      "account_digit" => "account_digit",
      "account_type" => "account_type",
      "profile_id" => "profile_id",
      "user_id" => "user_id"
    }
  end

  def response_mapping_hash
    {
      "id" => "remote_id",
      "profile_id" => "profile_id",
      "user_id" => "user_id",
      "bank_name" => "bank_name",
      "branch_number" => "branch_number",
      "branch_digit" => "branch_digit",
      "account_number" => "account_number",
      "account_digit" => "account_digit",
      "account_type" => "account_type",
      "created_at" => "created_at",
      "updated_at" => "updated_at"
    }
  end

end