class YearlyReportController < JsonController
  
  attr_accessor :profile, :wallet, :year, :yearly_report
  
  def viewDidLoad
    self.title = self.wallet.wallet_type.name
    super
    load_report
    back_button = self.load_back_button
    title_label = self.load_title

    unless settings[:title_color].nil?
      title_label.textColor = Theme.color(settings[:title_color])
    end
        
  end
  
  def noContentLabelColor
    UIColor.whiteColor
  end
  
  def load_report
    self.show_loading("Carregando...")
    report_manager = YearlyReportManager.shared_manager
    report_manager.delegate = self
    report_manager.fetch(wallet.remote_id, year: year)
  end
  
  def item_fetched(yearly_report)
    self.yearly_report = yearly_report
    self.data_table_view.reloadData
    self.dismiss_loading
  end
  
  def table_data
    if self.yearly_report.nil?
      []
    else
      [{rows: report_rows}, {title: "EXTRATO", rows: month_rows}]
    end
  end
  
  def report_rows
    [
      {cell_type: "report_chart", disabled: true, report: yearly_report, wallet: wallet}, 
      {cell_type: "report_data", disabled: true, report: yearly_report, wallet: wallet, month_label: "ÚLTIMO ANO"}
    ]
  end
  
  def month_rows
    self.yearly_report.months.map do |month_data|
      {
        cell_type: "simple", 
        label: I18n.translate(month_data[:name]), 
        action: "select_month", 
        action_param: month_data[:month], 
        disclosure: true
      }
    end
  end

  def select_month(month)
    monthly_report_controller = MonthlyReportController.new
    monthly_report_controller.month = month
    monthly_report_controller.wallet = wallet
    monthly_report_controller.profile = profile
    monthly_report_controller.yearly_report = yearly_report
    self.navigationController.pushViewController(monthly_report_controller, animated: true)
  end

end