class WithdrawalConfirmationController < JsonController
  
  attr_accessor :profile, :wallet, :withdrawal_request
  
  def viewDidLoad
    self.title = "Resgate Solicitado"
    super

    back_button = self.load_back_button
    unless settings[:back_button].nil?
      back_button.setImage(UIImage.imageNamed(settings[:back_button]), forState: UIControlStateNormal)
    end
        
    title_label = self.load_title
    unless settings[:title_color].nil?
      title_label.textColor = Theme.color(settings[:title_color])
    end
    
    self.outlets["amount_label"].text = "Você solicitou #{withdrawal_request.human_amount}"
  end
  
  def back
    self.navigationController.popToRootViewControllerAnimated(true)
  end
  
end