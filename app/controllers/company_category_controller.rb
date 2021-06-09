class CompanyCategoryController < JsonController
  attr_accessor :company_category, :delegate

  def viewDidLoad
    self.company_category = []
    # self.title = "Categories"
    # title_label = self.load_title
    # self.navigationItem.titleView = title_label
    super
    load_company_categories
    # load_title_button("Categories")
  end

  def viewWillAppear animated
    super
    self.navigationController.navigationBar.hidden = false

    load_title_button("Categorias")
  end
  
  def items_fetched(elements) 
    p elements
    self.company_category = elements
    self.data_table_view.reloadData    
    self.dismiss_loading
  end 

  def load_company_categories
    self.show_loading("Carregando...")   
    company_category_controller = CompanyCategoryManager.new 
    company_category_controller.prefix = "/"
    company_category_controller.prepare_mapping(company_category_controller.prefix)
    company_category_controller.delegate = self
    params = {name: {}}
    company_category_controller.fetch_all(params)
  end 

  def table_data
      [
        {rows: category_sections}
      ]
  end

  def category_sections
    if self.company_category.length > 0 
      self.company_category.map do |category_item| 
          {cell_type: "title_subtitle", title: category_item.name, subtitle: "", action: "select_category", action_param: {id: category_item.remote_id, name: category_item.name}, disclosure: true, leading: 50}
      end    
    else 
      data = [{cell_type: "simple", label: "No results"}]
    end 
  end 

  def select_category(categorydata)
    self.delegate.filter_type = "category"
    self.delegate.company_category = categorydata[:id]
    self.navigationController.popViewControllerAnimated(true)
  end

end