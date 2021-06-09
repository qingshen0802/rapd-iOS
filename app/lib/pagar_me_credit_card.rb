class PagarMeCreditCard
  
  attr_accessor :cardNumber, :cardHolderName, :cardExpirationMonth, :cardExpirationYear, :cardCvv, :delegate
  
  def initWithCardNumber(cardNumber, cardHolderName: cardHolderName, cardExpirationMonth: cardExpirationMonth, cardExpirationYear: cardExpirationYear, cardCvv: cardCvv)
    self.cardNumber = cardNumber
    self.cardHolderName = cardHolderName
    self.cardExpirationMonth = cardExpirationMonth
    self.cardExpirationYear = cardExpirationYear
    self.cardCvv = cardCvv
    
    self
  end
  
  def hasErrorCardNumber
    !cardNumber.isValidCreditCardNumber
  end
  
  def hasErrorCardHolderName
    cardHolderName.length <= 0
  end
  
  def hasErrorCardExpirationMonth
    cardExpirationMonth.to_i <= 0 || cardExpirationMonth > 12
  end
  
  def hasErrorCardExpirationYear
    false
  end
  
  def hasErrorCardCVV
    cardCvv.length < 3 || cardCvv.length
  end
  
  def cardExpirationDate
    "#{cardExpirationMonth}#{cardExpirationYear}"
  end
  
  def cardHashString
    ["cardNumber", "cardHolderName", "cardExpirationDate", "cardCvv"].map{|k| "#{k.underscore}=#{send(k)}"}.join("&")
  end
  
  def generateHash
    http_client = AFHTTPClient.alloc.initWithBaseURL(NSURL.URLWithString(PagarMe::API_ENDPOINT))
    
    http_client.getPath("/1/transactions/card_hash_key", parameters: {"encryption_key" => PagarMe.singleton.encryptionKey}, success: lambda{|operation, responseObject|
      response = NSJSONSerialization.JSONObjectWithData(responseObject, options:0, error:nil)
      encryptedString = RSA.encryptString(cardHashString, publicKey:response["public_key"])
      delegate.card_hash_generated(nil, "#{response["id"]}_#{encryptedString}")
    }, failure: lambda{|operation, error|
      delegate.card_hash_generated(error, nil)
    })
  end

end
