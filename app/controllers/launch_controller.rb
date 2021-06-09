class LaunchController < JsonController
  
  attr_accessor :profile_name, :profile_email
  
  def viewDidLoad
    super
    self.navigationController.navigationBar.hidden = true
  end
  
  def login
    self.navigationController.pushViewController(LoginController.new, animated: true)
  end

  def signup
    self.navigationController.pushViewController(SignupController.new, animated: true)
  end
  
  def facebookLogin
    # https://github.com/lucascorrea/SCFacebook
    SCFacebook.loginCallBack(lambda{|success, result|
      if success
        SCFacebook.getUserFields("email,first_name,last_name,picture,gender", callBack: lambda{|profile_success, profile_result|
          if profile_success
            user = User.new({
              email: profile_result["email"],
              facebook_id: result.token.userID,
              facebook_token: result.token.tokenString
            })
            
            self.profile_name = "#{profile_result["first_name"]} #{profile_result["last_name"]}"
            self.profile_email = profile_result["email"]
            
            user_manager = UserManager.shared_manager
            user_manager.delegate = self
            user_manager.create_resource(user)
          else
            app_delegate.display_error("Houve um erro na autenticação com o Facebook: Token inválida")
          end
        })
      else
        app_delegate.display_error("Houve um erro na autenticação com o Facebook")
      end
    })
  end
  
  def resource_created(user)
    store_user_locally(user)
    user.profile_ids ||= []

    if user.profile_ids.count > 0
      self.app_delegate.set_profile_ids(user.profile_ids)
      screen_manager.present_main
    else
      profile = Profile.new(full_name: self.profile_name, email: self.profile_email)
      screen_manager.present_signup(profile: profile)      
    end
  end
  
end