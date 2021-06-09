module TableViewDataSource
  
  def noContentLabelColor
    UIColor.lightGrayColor
  end
  
  def numberOfSectionsInTableView(tableView)
    if self.table_data.count == 0
      label = UILabel.alloc.initWithFrame(CGRectMake(0, 0, 200, 50))
      label.text = self.no_data_label
      label.textColor = noContentLabelColor
      label.numberOfLines = 0
      label.textAlignment = NSTextAlignmentCenter
      label.font = UIFont.systemFontOfSize(16.0)
      label.sizeToFit

      self.data_table_view.backgroundView = label
      self.data_table_view.separatorStyle = UITableViewCellSeparatorStyleNone
    else
      self.data_table_view.backgroundView = nil
      self.data_table_view.separatorStyle = standard_table_line_style
    end

    return table_data.count
  end

  def standard_table_line_style
    UITableViewCellSeparatorStyleSingleLine
  end

  def no_data_label
    "No content"
  end

  def tableView(tableView, numberOfRowsInSection: section)
    return table_data[section][:rows].count
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    cell_data = table_data[indexPath.section][:rows][indexPath.row]
    identifier = "#{cell_data[:cell_type]}_cell"
    cell = tableView.dequeueReusableCellWithIdentifier(identifier)    
    
    if cell.nil?
      klass = identifier.camelize.constantize
      cell = klass.alloc.init
    end
    
    cell.delegate = self
    if cell.delayed_load_from_json && cell.outlets.blank? && cell.loadFromJson
      cell.loadCell
      cell.loadComponents
    end    

    if cell_data[:disabled] == true
      cell.selectionStyle = UITableViewCellSelectionStyleNone
    end
    
    cell.set_data(cell_data)
    cell
  end

  def tableView(tableView, heightForRowAtIndexPath: indexPath)
    cell_data = table_data[indexPath.section][:rows][indexPath.row]
    if cell_data[:height].present?
      cell_data[:height]
    else
      table_view_settings[:cells][cell_data[:cell_type]] || 45.0
    end
  end

  def tableView(tableView, heightForHeaderInSection: section)
    section_data = table_data[section]
    if section_data[:title].present? && section_data[:title] != ""
      return 44.0
    else
      return 0
    end
  end
  
  def tableView(tableView, viewForHeaderInSection: section)
    section_data = table_data[section]

    header_view = UIView.alloc.initWithFrame(CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 40))
    label = UILabel.alloc.init
    label.textColor = Theme.tertiary_color
    label.font = UIFont.systemFontOfSize(15.0)
    header_view.addSubview(label)
    header_view.backgroundColor = UIColor.whiteColor

    label.place_auto_layout(leading: 20, trailing: -10, top: 5, height: 25)
    label.text = section_data[:title]
    header_view
  end
  
end