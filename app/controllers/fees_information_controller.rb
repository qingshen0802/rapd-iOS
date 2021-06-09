class FeesInformationController < JsonController
  
  def viewDidLoad
    self.title = "Prazos e Tarifas"    
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

  def back
    self.dismissViewControllerAnimated(true, completion: nil)
  end


end