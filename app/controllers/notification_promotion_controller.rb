class NotificationPromotionController < JsonController
    attr_accessor :notification, :to_user_id, :notifiable_id

    def viewDidLoad
        self.navigationController.navigationBar.hidden = true
        self.title = "PromotionNotification"
        super
        
        self.load_back_button
        self.load_title

        self.outlets["title_label"].text = "#{notification.title}"
        self.outlets["profile_image"].sd_setImageWithURL(NSURL.URLWithString(notification.to_user_photo_url), placeholderImage: UIImage.imageNamed("images/profile_placeholder.png"))
        #self.outlets["profile_icon"].sd_setImageWithURL(NSURL.URLWithString(notification.to_user_photo_url), placeholderImage: UIImage.imageNamed("images/profile_placeholder.png"))
        self.outlets['subtitle_label'].text = notification.created_at.time_count
        self.outlets['subtitle_label1'].text = notification.description.camelize(:lower)
    end    

    def resource_created(resource)
    end
    
    def resource_creation_failed
        self.app_delegate.display_message("Error", "Please try again!")
    end

    def resource_updated(element)
        self.to_user_id = element.to_profile_id
        remove_notification(self.notification)
    end

    def resource_update_failed
        p "Error"
    end

    def remove_notification(del_notification)
        self.notifiable_id = del_notification.notifiable_id
        noti_manager = NotificationManager.shared_manager
        noti_manager.delegate = self
        noti_manager.delete_resource(del_notification)
    end

    def resource_deleted
        back
    end

    def load_from_user_notifications
        from_user_manager = NotificationManager.shared_manager
        from_user_manager.delegate = self
        from_user_manager.fetch_all(profile_id: self.to_user_id)
    end
    
end
