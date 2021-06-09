class ContactController < JsonController
  
  attr_accessor :profile
  
  def viewDidLoad
    self.navigationController.navigationBar.hidden = true
    self.title = "Tratto"
    self.table_data = load_table_data
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
  
  def load_table_data
    [
      {rows: [
        {cell_type: "icon_title_subtitle", icon: "images/profile_help_icon.png", title: "Ajuda", subtitle: "Está com problemas? Nós te ajudamos", disclosure: true, action: "displayHelp"},
        {cell_type: "icon_title_subtitle", icon: "images/contact_about_icon.png", title: "Sobre Nós", subtitle: "Saiba um pouco sobre nós", disclosure: true, action: "about"},
        {cell_type: "icon_title_subtitle", icon: "images/contact_talk_icon.png", title: "Fale Conosco", subtitle: "Envie-nos uma mensagem", disclosure: true, action: "talk"},
      ]}
    ]
  end
  
  def about
    controller = WebController.new
    controller.title = "Sobre Nós"
    controller.url = "http://www.trat.to/about/index.html"

    self.screen_manager.present_modal(BaseNavigationController.with_controller(controller), self)    
  end
  
  def talk
    controller = WebController.new
    controller.title = "Fale Conosco"
    controller.url = "http://www.trat.to/contact/index.html"

    self.screen_manager.present_modal(BaseNavigationController.with_controller(controller), self)    
  end

   def displayHelp
    controller = WebController.new
    controller.title = "Ajuda"
    controller.url = "http://www.trat.to/faq/index.html"

    self.screen_manager.present_modal(BaseNavigationController.with_controller(controller), self)
  end

end