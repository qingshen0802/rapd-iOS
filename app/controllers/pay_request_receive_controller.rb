class PayRequestReceiveController < JsonController
  
  attr_accessor :profile, :transaction_request, :delegate, :selected_wallet
  
  def viewDidLoad
    super
    self.outlets["status_icon"].image = UIImage.imageNamed("images/transaction_success.png")    
    complete_message = "Você solicitou #{selected_wallet.short_name}#{transaction_request.amount} de \n#{profile.full_name}"

    self.outlets["status_value"].text = "#{selected_wallet.short_name}#{transaction_request.amount}"
    self.outlets["status_label1"].text = complete_message
    self.outlets["status_wallet"].text = selected_wallet.wallet_type.name
  end

  def viewWillAppear animated
    loadtitle
    self.outlets["status_label"].text = transaction_request.request_description
  end

  def loadtitle
    label = UILabel.new
    self.view.addSubview(label)
    label.place_auto_layout(top: 30, width: 270, height: 45, leading: 20)
    label.font = Fonts.font_named("Roboto-Black", 30)
    label.text = "Solicitação Feita"
    label.textAlignment = NSTextAlignmentLeft
    label.textColor = UIColor.blackColor
  end
  
  def finish_complete
    show_loading("Enviando...")
    manager = TransactionRequestManager.shared_manager
    manager.delegate = self
    manager.create_resource(transaction_request)  
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