class NotificationRequestCancelController < JsonController
    attr_accessor :notification, :transaction_reqeust, :rapd_transaction, :selected_wallet, :current_currency_id, :to_user_id, :notifiable_id

    def viewDidLoad
        self.navigationController.navigationBar.hidden = true
        self.title = notification.to_user_name
        super
        
        self.load_back_button
        self.load_title

        self.outlets["title_label"].text = "#{notification.description.camelize(:lower)}"
        self.outlets["profile_image"].sd_setImageWithURL(NSURL.URLWithString(notification.to_user_photo_url), placeholderImage: UIImage.imageNamed("images/profile_placeholder.png"))
        self.outlets["profile_icon"].sd_setImageWithURL(NSURL.URLWithString(notification.to_user_photo_url), placeholderImage: UIImage.imageNamed("images/profile_placeholder.png"))
        self.outlets['subtitle_label'].text = notification.created_at.time_count
        self.outlets['subtitle_label1'].text = notification.created_at.time_count

        load_transaction_request
    end    

    def cancel_request
        cancel_payment
    end

    def item_fetched(element)
        if element.is_a?(TransactionRequest)
            self.transaction_reqeust = element
            if self.transaction_reqeust.status == "canceled" || self.transaction_reqeust.status == "processed"
                self.outlets["cancel_button"].enabled = false
                if self.transaction_reqeust.status == "canceled"
                    self.outlets['state_label'].text = "This transaction request has been canceled."
                elsif self.transaction_reqeust.status == "processed"
                    self.outlets['state_label'].text = "This transaction request is already processed."
                else
                    self.outlets['state_label'].text = ""
                end
            else
                self.outlets["cancel_button"].enabled = true
            end
            self.outlets["des_label"].text = self.transaction_reqeust.request_description
            self.current_currency_id = transaction_reqeust.currency_id
            load_wallet            
        else
        end        
    end

    def items_fetched(elements)
        if elements.first.is_a?(Wallet)
            elements.each do |wallet|
                if wallet.wallet_type_id == current_currency_id
                    self.selected_wallet = wallet
                else
                end
            end            
        elsif elements.first.is_a?(Notification)
            elements.each do |notification|                
                if notification.notifiable_id == self.notifiable_id
                    remove_notification(notification)
                    break
                else
                end
            end
        end
    end 

    def load_transaction_request
        request_manager = TransactionRequestManager.shared_manager
        request_manager.delegate = self
        request_manager.fetch(notification.notifiable_id)
    end

    def load_wallet
        wallet_manager = WalletManager.shared_manager
        wallet_manager.delegate = self
        wallet_manager.fetch_all(profile_id: app_delegate.current_profile_id, withdrawable: true)    
    end

    def cancel_payment
        update_transaction_reqeust
    end

    def resource_created(resource)
    end
    
    def resource_creation_failed
        self.app_delegate.display_message("Error", "Please try again!")
    end

    def update_transaction_reqeust
        self.transaction_reqeust.status = "canceled"
        self.transaction_reqeust.to_profile_id = self.transaction_reqeust.from_profile_id
        self.transaction_reqeust.from_profile_id = app_delegate.current_profile_id   
        request_udpate_manager = TransactionRequestManager.shared_manager
        request_udpate_manager.delegate = self
        request_udpate_manager.update_resource(self.transaction_reqeust)
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
