class StripePaymentCollectionController < BaseController

  attr_accessor :payment_field, :payment_button, :form_view, :logo, :transaction_manager,
                :plan_title_label, :plan_label, :description_label, :parent_controller

  def viewDidLoad
    super
    self.title = "Payment Info"

    self.form_view = FormView.get_form(delegate: self)
    self.view.addSubview(self.form_view)
    self.form_view.place_expanded_into_view(self.view)

    self.payment_field = STPPaymentCardTextField.alloc.init
    self.form_view.addSubview(self.payment_field)
    self.payment_field.place_auto_layout(leading: 60, trailing: -60, center_x: 0, height: 30, center_y: -170)
    self.payment_field.delegate = self

    self.payment_button = MainButton.get_button(title: "Submit Payment", target: self, action: "submit")
    self.form_view.addSubview(payment_button)
    self.payment_button.place_auto_layout(leading: 60, trailing: -60, center_x: 0, height: 30, center_y: -120)
    self.payment_button.enabled = false

    self.logo = UIImageView.alloc.init
    self.logo.image = UIImage.imageNamed("images/secure-stripe.png")
    self.form_view.addSubview(logo)
    self.logo.place_auto_layout(width: 119, center_x: -5, height: 54, center_y: -70)

    self.description_label = UILabel.alloc.init
    self.form_view.addSubview(self.description_label)
    self.description_label.textAlignment = NSTextAlignmentCenter
    self.description_label.place_auto_layout(leading: 60, trailing: -60, center_y: 60, height: 200)
    self.description_label.text = "Please enter your credit card info to upgrade to the paid membership for Hiraa.\n\nAs a subscribed member, you have access to features such as marking users as favorites or starting conversations with anyone.\n\nYou can stop your subscription\nat any time."
    self.description_label.numberOfLines = 0
    self.description_label.font = Fonts.normal_font_bold(13.0)

    self.plan_title_label = UILabel.alloc.init
    self.form_view.addSubview(self.plan_title_label)
    self.plan_title_label.place_auto_layout(width: 200, center_x: -20, center_y: 180, height: 20)
    self.plan_title_label.text = "Standard: "
    self.plan_title_label.font = Fonts.normal_font_bold(16.0)

    self.plan_label = UILabel.alloc.init
    self.form_view.addSubview(self.plan_label)
    self.plan_label.place_auto_layout(width: 200, center_x: 20, center_y: 180, height: 20)
    self.plan_label.textAlignment = NSTextAlignmentRight
    self.plan_label.text = "US$ 19.99 per month"
    self.plan_label.font = Fonts.normal_font(16.0)

    self.setup_right_nav_button("Close", "close")
  end

  def textFieldShouldBeginEditing(textField)
    self.form_view.setContentOffset(CGPointMake(0, 100), animated: true)
    true
  end

  def textFieldShouldReturn(textField)
    textField.resignFirstResponder
    true
  end

  def close
    self.dismissModalViewControllerAnimated(true, completion: nil)
  end

  def paymentCardTextFieldDidChange(text_field)
    self.payment_button.enabled = text_field.isValid
  end

  def dismissKeyboard
    self.payment_field.resignFirstResponder    
    self.form_view.resetPosition
  end  

  def submit
    self.payment_button.enabled = false
    show_loading("Processing Payment")

    card = STPCardParams.alloc.init
    card.number = self.payment_field.card.number
    card.expMonth = self.payment_field.card.expMonth
    card.expYear = self.payment_field.card.expYear
    card.cvc = self.payment_field.card.cvc
  
    STPAPIClient.sharedClient.createTokenWithCard(card, completion: lambda{|token, error|
      if error
        self.payment_button.enabled = true
        self.dismiss_loading        
        app_delegate.display_error(error.userInfo["com.stripe.lib:ErrorMessageKey"])
      else
        submit_transaction(token.tokenId)
      end
    })
  end

  def submit_transaction(token_id)
    transaction = Transaction.new
    transaction.stripe_token = token_id

    self.transaction_manager = TransactionManager.shared_manager
    self.transaction_manager.delegate = self
    self.transaction_manager.create_resource(transaction)
  end

  def resource_created(resource)
    self.payment_button.enabled = true
    self.dismiss_loading
  end

end