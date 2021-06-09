class HomeController < JsonController
  
  attr_accessor :companies, :query, :wallet_controller, :contacts
  
  def viewDidLoad
    self.title = ""
    
    super
  end
  
  def loadtitle
    label = UILabel.new
    self.view.addSubview(label)
    label.place_auto_layout(top: 30, width: 270, height: 45, leading: 20)
    label.font = Fonts.font_named("Roboto-Black", 30)
    label.text = "Enviar ou Solicitar"
    label.textAlignment = NSTextAlignmentLeft
    label.textColor = UIColor.blackColor
  end
  
  def toggle_filter
    p "=== TOGGEL FILTER ==="
  end

  def viewWillAppear animated
    super
    self.navigationController.navigationBar.hidden = true
    loadtitle
  end
  
  def viewDidAppear(animated)
    super(animated)
    
    load_companies
    # load_contacts
    load_peoples
  end
  
  def load_companies
    self.show_loading("Carregando...")
    
    CompanyManager.manager = nil
    manager = CompanyManager.shared_manager
    manager.delegate = self
    manager.fetch_all(search: {name: query})
  end
  
  def load_contacts
    self.show_loading("Carregando...")
    
    manager = ContactManager.shared_manager
    manager.delegate = self
    manager.fetch_all({query: self.query, profile_id: app_delegate.current_profile_id})
  end

  def load_peoples
    self.show_loading("Carregando...")

    manager = PeopleManager.shared_manager
    manager.delegate = self
    manager.fetch_all(search: {name: query})
  end
  
  def items_fetched(elements)
    if elements.any?
      if elements.first.is_a?(Company)
        self.companies = elements        
        # load_contacts
        load_peoples
      elsif elements.first.is_a?(Contact)
        # self.contacts = elements
        load_peoples
      elsif elements.first.is_a?(People)
        self.contacts = elements
      end
    end
    
    self.table_data = load_table_data
    self.data_table_view.reloadData
    dismiss_loading
  end
  
  def load_table_data
    rows = []
    if self.companies
      rows << {cell_type: "subtitle", title: "Sugestões", action: "", disable_selection: true, leading: 20}
      
      self.companies.sort_by(&:distance).each do |profile|
        rows << {cell_type: "list_business_my", icon_url: profile.photo_url, title: profile.full_name, subtitle: profile.distance, disclosure: true, action: "select_profile", action_param: profile}
      end
    end
    p self.query
    if self.contacts && !self.query.nil? && !self.query.empty?
      rows << {cell_type: "subtitle", title: "Contatos", action: "", disable_selection: true, leading: 20}
      
      self.contacts.sort_by(&:full_name).each do |contact|
        profile = contact
        
        rows << {cell_type: "list_business", icon_url: profile.photo_url, title: profile.full_name, subtitle: profile.username, disclosure: true, action: "select_profile", action_param: profile}
      end
    end
    
    [{rows: rows}]
  end
  
  def select_profile(profile)
    controller = PayRequestController.new
    controller.profile = profile
    controller.wallet_controller = wallet_controller
    
    outlets['search_view'].text = ""
    
    self.navigationController.pushViewController(controller, animated: true)
  end
  
  def performSearch
    load_companies
    load_peoples
  end
  
end