class Notification < BaseEntity
  attr_accessor :type, :notifiable_id, :notifiable_type, :user_id , :profile_id, :title,
                :description, :read ,:importance, :created_at, :updated_at, :color, :from_user_photo_url, :from_user_name, :to_user_photo_url, :to_user_name
end
