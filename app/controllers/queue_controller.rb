class QueueController < JsonController
  
  def viewDidLoad
    self.title = "Lista de Espera"
    super
    
    title_label = self.load_title
    
    unless settings[:title_color].nil?
      title_label.textColor = Theme.color(settings[:title_color])
    end
    
    self.navigationController.navigationBar.hidden = true
  end  
  
end