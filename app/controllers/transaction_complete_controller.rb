class TransactionCompleteController < JsonController
  
  attr_accessor :profile, :transaction, :delegate, :selected_wallet
  
  def viewDidLoad
    super
    load_title_btn("Enviar ou Solicitar")

    self.outlets["status_icon"].image = UIImage.imageNamed("images/Shape.png")
    self.outlets["status_icon1"].image = UIImage.imageNamed("images/Group.png")
    self.outlets["status_tw"].setBackgroundImage(UIImage.imageNamed("images/twiter_icon.png"), forState: UIControlStateNormal)
    self.outlets["status_fb"].setBackgroundImage(UIImage.imageNamed("images/facebook_icon.png"), forState: UIControlStateNormal)
    
    complete_message = "Você pagou #{selected_wallet.short_name}#{transaction.amount}"
    # complete_message = "Você pagou R$ #{transaction.amount} para \n#{profile.full_name} e utilizou R$ #{transaction.amount} do \nseu clube de compras."    

    self.outlets["status_value"].text = "#{selected_wallet.short_name}#{transaction.amount}"
    self.outlets["status_label1"].text = complete_message
    self.outlets["status_title"].text = profile.full_name
    self.outlets["status_wallet"].text = selected_wallet.wallet_type.name
  end

  def viewWillAppear animated
      self.outlets["status_label"].text = transaction.transaction_description
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
  
  def click_fb
      p "fb clicked"
  end
  
  def click_tw
      p "twiter clicked"
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