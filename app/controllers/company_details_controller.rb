class CompanyDetailsController < JsonController

  attr_accessor :store, :browse_controller, :favorite, :current_profile

  def viewDidLoad 
    self.title = store.full_name
    title_label = self.load_title
    self.favorite = false 

    self.navigationItem.titleView = title_label
    self.navigationController.navigationBar.translucent = false

    super
    unless settings[:title_color].nil?
      title_label.textColor = Theme.color(settings[:title_color])
    end
    load_backbutton
    load_favorites_button
    load_current_profile
  end 

  def viewWillAppear animated
    self.navigationController.navigationBar.hidden = false 
  end

  def table_data
    if store.discount_club_active
      [
        {rows: [
          {cell_type: "company_details_picture", disabled: true, store: store},
          {cell_type: "company_details_direction", disabled: true, store: store},
          {cell_type: "company_details_info", disabled: true, store: store},
          {cell_type: "company_details_contact", disabled: true, store: store},
          {cell_type: "company_details_discount", disabled: true, store: store},
          {cell_type: "company_details_promotions", disabled: true, store: store}
        ]
        }
      ]
    else
      [
        {rows: [
          {cell_type: "company_details_picture", disabled: true, store: store},
          {cell_type: "company_details_direction", disabled: true, store: store},
          {cell_type: "company_details_info", disabled: true, store: store},
          {cell_type: "company_details_contact", disabled: true, store: store},
          {cell_type: "company_details_discount", disabled: true, store: store, height: 80}
        ]
        }
      ]
    end
  end

  def load_backbutton
    button = UIButton.new
    self.view.addSubview(button)
    button.place_auto_layout(top: 20, leading: 10, width: 35, height: 35)
    button.setImage(UIImage.imageNamed("images/back-button.png"), forState: UIControlStateNormal)
    button.addTarget(self, action: NSSelectorFromString("back"), forControlEvents: UIControlEventTouchUpInside)
    back_button = UIBarButtonItem.alloc.initWithCustomView(button)
    self.navigationItem.leftBarButtonItem = back_button
  end

  def back
    self.navigationController.popViewControllerAnimated(true)
  end

  def load_favorites_button
    button = UIButton.new
    self.view.addSubview(button)
    if self.favorite == true 
      button.setImage(UIImage.imageNamed("images/favorites_selected.png"), forState: UIControlStateNormal)
    else 
      button.setImage(UIImage.imageNamed("images/favorites_unselected.png"), forState: UIControlStateNormal)
    end 
    button.addTarget(self, action: NSSelectorFromString("toggle_favorite"), forControlEvents: UIControlEventTouchUpInside)    
    button.frame = CGRectMake(100, 55, 20, -20)     
    favorite_button = UIBarButtonItem.alloc.initWithCustomView(button)
    self.navigationItem.rightBarButtonItem = favorite_button 
  end

  def view_site
    if !store.url.blank?
      UIApplication.sharedApplication.openURL(NSURL.URLWithString(store.url))
    else
      show_alert("Error", "URL is incorrect")
    end
  end 

  def call_store
    if !store.phone_number.blank?
      phone = "tel://" + store.phone_number
      UIApplication.sharedApplication.openURL(NSURL.URLWithString(phone))
    else
      show_alert("Error", "Phone Number is incorrect")
    end
  end 

  def make_payment(amount)
    if amount.blank? || amount == 0
      show_alert("Error", "Please input valid value!")
    else
      pay_request_controller = PayRequestController.new
      wallets_controller = WalletsController.new
      wallets_controller.delegate = self
      wallets_controller.profile = current_profile
      pay_request_controller.wallet_controller = wallets_controller
      pay_request_controller.profile = store
      pay_request_controller.payment = amount 
      self.navigationController.pushViewController(pay_request_controller, animated: true)
    end
  end 

  def information
  end 

  def toggle_favorite
    self.favorite == true ? self.favorite = false : self.favorite = true 
    load_favorites_button
  end 

  def view_map
    locationview_controller = GoogleMapsController.new
    locationview_controller.store = store
    self.navigationController.pushViewController(locationview_controller, animated: true)
  end 

  def show_alert(title, message)
    alert = UIAlertView.alloc.initWithTitle(title, 
                                message: message, 
                                delegate: nil, 
                                cancelButtonTitle: "Close", 
                                otherButtonTitles: nil)
    alert.show
  end

end 