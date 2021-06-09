class PagarMe
  
  API_ENDPOINT = "https://api.pagar.me/1"
  
  cattr_accessor :shared_instance
  attr_accessor :encryptionKey
  
  def self.singleton
    if @@shared_instance.nil?
      @@shared_instance = new
    end
    @@shared_instance
  end
  
end