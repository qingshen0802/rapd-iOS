class ReferralsController < JsonController

  attr_accessor :referrals, :profile, :query
  
  def viewDidLoad
    self.title = "Meus indicados"
    super
    load_referrals
    back_button = self.load_back_button
    title_label = self.load_title    
    unless settings[:title_color].nil?
      title_label.textColor = Theme.color(settings[:title_color])
    end
  end
  
  def noContentLabelColor
    UIColor.whiteColor
  end
  
  def performSearch
    load_referrals
  end
  
  def load_referrals
    referral_manager = ReferralManager.shared_manager
    referral_manager.delegate = self
    referral_manager.fetch_all(query: query)
  end
  
  def items_fetched(referrals)
    self.referrals = referrals
    self.data_table_view.reloadData
  end
  
  def referrals_rows
    referrals.map{|referral|
      profile_photo = referral.referred.photo_url if !referral.referred.nil? && !referral.referred.photo_url.nil?
      {cell_type: "profile", name: referral.referred.full_name, username: referral.referred.username, photo: profile_photo, id: referral.remote_id, profile_type: referral.referred.profile_type, action: "select_profile", action_param: referral.referred, inverse: true, disclosure: true}
    }
  end
  
  def table_data
    if self.referrals.nil? || self.referrals.to_a.count == 0
      []
    else
      [{rows: referrals_rows}]
    end
  end
  
  def show_profile(profile)
    public_profile_form = PublicProfileForm.new
    public_profile_form.profile = profile
    self.navigationController.pushViewController(public_profile_form, animated: true)
  end

end