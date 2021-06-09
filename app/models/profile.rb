class Profile < BaseEntity

  attr_accessor :profile_type, :photo, :photo_url, :photo_mime_type, :cover_photo_url, :full_name, 
                :document_id, :email, :is_legal_representer, :accepts_terms, 
                :is_legal_represented, :legal_representer_name, :legal_representer_document_id, 
                :legal_representer_email, :username, :user_id, :birth_date,
                :company_category_name, :company_category_id, :current_document_status,
                :bank_account_id, :facebook_active, :twitter_active, :google_plus_active, 
                :instagram_active, :referral_link, :push_notifications_active, :touch_id_active,
                :automatic_bonus, :discount_club_active, :discount_club_bonus_amount, 
                :discount_club_bonus_requirement, :discount_club_bonus_period, :distance,
                :phone_number, :description, :address, :url, :credits_amount
  
  def any_attachment?
    [photo].map(&:present?).include?(true)
  end

end