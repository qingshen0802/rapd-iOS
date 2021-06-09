class PayRequestSendController < JsonController
  
  attr_accessor :profile, :transaction, :delegate, :selected_wallet
  
  def viewDidLoad
    super
    self.outlets["status_icon"].image = UIImage.imageNamed("images/transaction_success.png")
    if profile.discount_club_active
      complete_message = "Você pagou #{selected_wallet.short_name}#{transaction.amount} para \n#{profile.full_name} e utilizou #{selected_wallet.short_name}#{profile.discount_club_bonus_amount} do seu clube de compras."
      transaction.amount -= profile.discount_club_bonus_amount
    else
      complete_message = "Você pagou #{selected_wallet.short_name}#{transaction.amount} para \n#{profile.full_name}"
    end    

    self.outlets["status_value"].text = "#{selected_wallet.short_name}#{transaction.amount}"
    self.outlets["status_label1"].text = complete_message
    self.outlets["status_wallet"].text = selected_wallet.wallet_type.name
  end

  def viewWillAppear animated
    loadtitle
    self.outlets["status_label"].text = transaction.transaction_description
  end
  
  def loadtitle
    label = UILabel.new
    self.view.addSubview(label)
    label.place_auto_layout(top: 30, width: 270, height: 45, leading: 20)
    label.font = Fonts.font_named("Roboto-Black", 30)
    label.text = "Envio Realizado"
    label.textAlignment = NSTextAlignmentLeft
    label.textColor = UIColor.blackColor
  end

  def finish_complete
    show_loading("Enviando...")
    manager = RapdTransactionManager.shared_manager
    manager.delegate = self
    manager.create_resource(transaction)    
  end

  def finish_incomplete
    self.dismissViewControllerAnimated(true, completion: nil)
  end

  def resource_created(resource)
    dismiss_loading
    self.delegate.from_transaction = true
    self.dismissViewControllerAnimated(true, completion: nil)
  end
  
  def resource_creation_failed
  end
  
  def load_title_btn(title=self.title)
    label = UILabel.new
    self.view.addSubview(label)
    label.place_auto_layout(top: 30, width: 250, leading: 20)
    label.font = Fonts.font_named("Roboto-Bold", 26)
    label.text = title
    label.textColor = UIColor.blackColor
    
    title_button = UIBarButtonItem.alloc.initWithCustomView(label)
    
    self.navigationItem.leftBarButtonItem = title_button
    self.navigationItem.titleView = UIView.new
  end
end