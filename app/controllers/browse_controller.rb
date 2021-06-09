class BrowseController < JsonController
  attr_accessor :query, :filter_type, :store_filter_type, :store , :companies, :company_category

  def viewDidLoad
    self.companies = []
    self.title = "Rede"
    self.filter_type = "proximity"
    self.store_filter_type = "all"
    super
    load_companies
    # loadtitle(self.title)
    # load_title_button("Rede Tratto")
    # load_right_button(title: "Filtro", action: "toggle_filter")
  end

  def viewWillAppear animated
    super
    load_companies
    self.navigationController.navigationBar.hidden = true    
    loadMainTitle
  end

  def loadMainTitle
    label = UILabel.new
    self.view.addSubview(label)
    label.place_auto_layout(top: 30, width: 270, height: 45, leading: 20)
    label.font = Fonts.font_named("Roboto-Black", 30)
    label.text = self.title
    label.textAlignment = NSTextAlignmentLeft
    label.textColor = UIColor.blackColor

    button = UIButton.new
    button.setTitle("Filtrar", forState: UIControlStateNormal)
    self.view.addSubview(button) 
    button.setTitleColor(Theme.main_color, forState: UIControlStateNormal)
    button.titleLabel.font = Fonts.font_named("Roboto-Medium", 18)
    button.place_auto_layout(top: 35, trailing: -20, width: 65, height: 35)
    button.addTarget(self, action: NSSelectorFromString("toggle_filter"), forControlEvents: UIControlEventTouchUpInside)  
  end
  
  def items_fetched(elements) 
    self.companies = elements
    self.data_table_view.reloadData
    self.dismiss_loading
  end 

  def load_companies
    self.show_loading("Carregando...")
    company_manager = CompanyManager.new 
    company_manager.prefix = "/"
    company_manager.prepare_mapping(company_manager.prefix)
    company_manager.delegate = self
    filtertype = self.filter_type
    case filtertype
      when "proximity"
         params = {search: {proximity: ''}}
      when "discount_club"
         params = {search: {discount_club: 1}}
      when "favorite"
         params = {search: {favorite: 1 }}
      when "name"
         params = {search: {name: "#{self.query}"}}
      when "category"
         params = {search: {company_category_id: "#{self.company_category}"}}
      else
         params = {search: {name: ''}}
    end
    company_manager.fetch_all(params)
  end 

  def toggle_filter
    controller = CompanyCategoryController.new
    controller.delegate = self
    self.navigationController.pushViewController(controller, animated: true)
  end

  def table_data
      [
        {rows: [
           {cell_type: "browse_filters", disabled: true, current_filter_type: filter_type},
           {cell_type: "browse_store_filters", disabled: true, current_store_filter_type: store_filter_type}
        ]+ 
      store_sections}
      ]
  end

  def store_sections
    if self.companies.length > 0 
      self.companies.map do |store| 
          {cell_type: "browse_store", store: store, action: "view_store", action_param: store}
      end    
    else 
      data = [{cell_type: "simple", label: "No results"}]
    end 
  end 

  def filter(type)
    self.filter_type = type
    load_companies
  end

  def store_filter(type)
    self.store_filter_type = type
    self.data_table_view.reloadData
  end 

  def view_store(store)
    account_controller = CompanyDetailsController.new
    account_controller.store = store
    account_controller.browse_controller = self
    self.navigationController.pushViewController(account_controller, animated: true)
  end

  def searchBar(searchBar, textDidChange: searchText)
    self.query = searchText
    NSObject.cancelPreviousPerformRequestsWithTarget(self, selector: "performSearch", object: nil)
    self.performSelector("performSearch", withObject: nil, afterDelay: 0.5)
  end 

  def performSearch
    self.filter_type = "name"
    load_companies
  end  

end