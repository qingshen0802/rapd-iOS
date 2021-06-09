class PrepaidCardController < JsonController
  
  
  def viewDidLoad
    self.title = "Cartão Tratto Pré Pago"    
    super

    back_button = self.load_back_button
    unless settings[:back_button].nil?
      back_button.setImage(UIImage.imageNamed(settings[:back_button]), forState: UIControlStateNormal)
    end
        
    title_label = self.load_title
    unless settings[:title_color].nil?
      title_label.textColor = Theme.color(settings[:title_color])
    end
  end
  
  def requestCard
    controller = RequestPrepaidCardController.new
    controller.profile = self.profile
    self.navigationController.pushViewController(controller, animated: true)            
  end
  
end