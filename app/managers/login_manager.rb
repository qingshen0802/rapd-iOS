class LoginManager

  cattr_accessor :manager
  attr_accessor :delegate

  def self.shared_manager
    if @@manager.nil?
      @@manager = new
    end
    @@manager
  end

  def app_delegate
    UIApplication.sharedApplication.delegate
  end

  def login(email, password)
    url = NSURL.URLWithString("#{app_delegate.base_url}/api/tokens.json")
    error = nil
    response = nil

    request = NSMutableURLRequest.requestWithURL(url)
    request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
    request.setValue("Token token=#{app_delegate.api_access_token}", forHTTPHeaderField: "Authorization")
    request.HTTPMethod = "POST"
    request.HTTPBody = NSJSONSerialization.dataWithJSONObject({email: email, password: password}, options: NSJSONWritingPrettyPrinted, error: error)
    data = NSURLConnection.sendSynchronousRequest(request, returningResponse: response, error: error)

    if data.nil?
      app_delegate.display_error("Could not get data from the server")
    else
      data_hash = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingMutableContainers, error: error)
      if data_hash[:error]
        app_delegate.display_error(data_hash[:message])
        delegate.login_failed
      else
        app_delegate.set_user(data_hash[:user].merge(remote_id: data_hash[:user][:id]))
        app_delegate.set_profile_ids(data_hash[:user][:profile_ids])
        delegate.logged_in        
      end
    end
  end

end