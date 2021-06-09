class FilterController < JsonController
  
  attr_accessor :delegate
  
  def viewDidLoad
    self.title = "Filtrar"
    
    super    
    # load_title_button
    self.table_data = load_table_data
  end

  def viewWillAppear animated
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
  end
    
  def load_table_data
    [{rows: [
      {cell_type: "title_subtitle", title: "Todas", subtitle: "", action: "select_filter", action_param: {value: nil, label: nil}, disclosure: true, leading: 50},
      {cell_type: "title_subtitle", title: "Pagamentos", subtitle: "", action: "select_filter", action_param: {value: "Payment", label: "Pagamentos"}, disclosure: true, leading: 50},
      {cell_type: "title_subtitle", title: "Recebimentos", subtitle: "", action: "select_filter", action_param: {value: "Receipt", label: "Recebimentos"}, disclosure: true, leading: 50},
      {cell_type: "title_subtitle", title: "Solicitações de pagamento", subtitle: "", action: "select_filter", action_param: {value: "PaymentRequest", label: "Solicitações de pagamento"}, disclosure: true, leading: 50},
      {cell_type: "title_subtitle", title: "Avisos", subtitle: "", action: "select_filter", action_param: {value: "Warning", label: "Avisos"}, disclosure: true, leading: 50},
      {cell_type: "title_subtitle", title: "Promoções", subtitle: "", action: "select_filter", action_param: {value: "Promotion", label: "Promoções"}, disclosure: true, leading: 50},
      {cell_type: "title_subtitle", title: "Conversas", subtitle: "", action: "select_filter", action_param: {value: "Mention", label: "Conversas"}, disclosure: true, leading: 50},
      {cell_type: "subtitle", title: "Ordem", action: "", disable_selection: true, leading: 20},
      {cell_type: "title_subtitle", title: "Mais recentes", subtitle: "", action: "select_order", action_param: {value: "newest", label: "Mais recentes"}, disclosure: true, leading: 50},
      {cell_type: "title_subtitle", title: "Mais antigas", subtitle: "", action: "select_order", action_param: {value: "older", label: "Mais antigas"}, disclosure: true, leading: 50},
    ]}]
  end
  
  def select_filter(filter_data)
    self.delegate.filter_type = filter_data[:value]
    self.delegate.filter_name = filter_data[:label]
    self.navigationController.popViewControllerAnimated(true)
  end
  
  def select_order(filter_data)
    self.delegate.filter_order = filter_data[:value]
    self.delegate.filter_name = filter_data[:label]
    self.navigationController.popViewControllerAnimated(true)
  end
  
end
