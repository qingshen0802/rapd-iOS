class RestClient

  attr_accessor :body, :response_data, :error

  def new_request(url_string, access_token)
    url = NSURL.URLWithString(url_string)
    
    request = NSMutableURLRequest.requestWithURL(url)
    request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
    request.setValue("Token token=#{access_token}", forHTTPHeaderField: "Authorization")
    request
  end

  def get(path, access_token)
    error = nil
    response = nil    
    request = new_request(path, access_token)
    request.HTTPMethod = "GET"
    data = NSURLConnection.sendSynchronousRequest(request, returningResponse: response, error: error)

    if data.nil?
      self.error = "Could not get data from the server"
      return nil
    else
      self.response_data = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingMutableContainers, error: error)
      return self.response_data
    end
  end

  def post(path, access_token, body)
    request = new_request(path, access_token)
    request.HTTPMethod = "POST"
    request.HTTPBody = NSJSONSerialization.dataWithJSONObject(body, options: NSJSONWritingPrettyPrinted, error: error) if body.present?        
    data = NSURLConnection.sendSynchronousRequest(request, returningResponse: response, error: error)

    if data.nil?
      self.error = "Could not get data from the server"
      return nil
    else
      self.response_data = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingMutableContainers, error: error)
      return self.response_data
    end
  end
  
end