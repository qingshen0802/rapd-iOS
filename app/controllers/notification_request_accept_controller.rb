class NotificationRequestAcceptController < JsonController
    attr_accessor :notification, :transaction_reqeust, :rapd_transaction, :selected_wallet, :current_currency_id, :from_user_id, :notifiable_id

    def viewDidLoad
        self.navigationController.navigationBar.hidden = true
        self.title = notification.from_user_name
        super
        
        self.load_back_button
        self.load_title

        self.outlets["title_label"].text = "#{notification.description.camelize(:lower)}"
        self.outlets["profile_image"].sd_setImageWithURL(NSURL.URLWithString(notification.from_user_photo_url), placeholderImage: UIImage.imageNamed("images/profile_placeholder.png"))
        self.outlets["profile_icon"].sd_setImageWithURL(NSURL.URLWithString(notification.from_user_photo_url), placeholderImage: UIImage.imageNamed("images/profile_placeholder.png"))
        self.outlets['subtitle_label'].text = notification.created_at.time_count
        self.outlets['subtitle_label1'].text = notification.created_at.time_count

        load_transaction_request
    end    

    def accept_request
        if self.selected_wallet.blank?
            self.app_delegate.display_message("Error", "You don't have this wallet!")
        else
            if self.selected_wallet.balance >= transaction_reqeust.amount
                make_payment
            else
                self.app_delegate.display_message("Error", "There is no enough money in your wallet!")
            end
        end
    end

    def item_fetched(element)
        if element.is_a?(TransactionRequest)
            self.transaction_reqeust = element
            p self.transaction_reqeust
            if self.transaction_reqeust.status == "canceled" || self.transaction_reqeust.status == "processed"
                self.outlets["accept_button"].enabled = false
                if self.transaction_reqeust.status == "canceled"
                    self.outlets['state_label'].text = "This transaction request has been canceled."
                elsif self.transaction_reqeust.status == "processed"
                    self.outlets['state_label'].text = "This transaction request is already processed."
                else
                    self.outlets['state_label'].text = ""
                end
            else
                self.outlets["accept_button"].enabled = true
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

    def make_payment
        rapd_transaction = RapdTransaction.new
        rapd_transaction.from_profile_id = app_delegate.current_profile_id
        rapd_transaction.to_profile_id = transaction_reqeust.from_profile_id
        self.from_user_id = transaction_reqeust.from_profile_id
        rapd_transaction.amount = transaction_reqeust.amount.to_f * 100 / 100.00
        rapd_transaction.transaction_description = "Test"
        rapd_transaction.from_wallet_id = selected_wallet.remote_id
        rapd_transaction.rapd_transaction_type = "deposit_request"

        manager = RapdTransactionManager.shared_manager
        manager.delegate = self
        manager.create_resource(rapd_transaction)
    end

    def resource_created(resource)
        update_transaction_reqeust
    end
    
    def resource_creation_failed
        self.app_delegate.display_message("Error", "Please try again!")
    end

    def update_transaction_reqeust
        self.transaction_reqeust.status = "processed"
        self.transaction_reqeust.to_profile_id = self.transaction_reqeust.from_profile_id
        self.transaction_reqeust.from_profile_id = app_delegate.current_profile_id        
        request_udpate_manager = TransactionRequestManager.shared_manager
        request_udpate_manager.delegate = self
        request_udpate_manager.update_resource(self.transaction_reqeust)
    end
    def resource_updated(element)
        if element.is_a?(TransactionRequest)
            self.from_user_id = element.from_profile_id
            remove_notification(self.notification)
        else
        end
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
        from_user_manager.fetch_all(notifiable_id: self.notifiable_id, profile_id: self.from_user_id)
    end
    
end
