class ReportChartCell < BaseCell
  
  attr_accessor :chart_data, :report
  
  def set_data(data = {})
    super(data)
    self.chart_data = data[:chart_data]
    self.report = data[:report]
    self.outlets["data_chart"].reloadGraph
  end
  
  def points
    report.months.reverse.map{|m| m[:balance]}
  end
  
  def point_labels
    report.months.reverse.map{|m| m[:short_name]}
  end
  
  def lineGraph(graph, labelOnXAxisForIndex: index)
    return point_labels[index]
  end
    
  def numberOfPointsInLineGraph(graph)
    return points.count
  end
  
  def lineGraph(graph, valueForPointAtIndex: index)
    points[index]
  end

end