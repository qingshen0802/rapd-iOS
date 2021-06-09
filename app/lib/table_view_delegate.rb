module TableViewDelegate
  
  def tableView(tableView, didSelectRowAtIndexPath: indexPath)
    cell_data = table_data[indexPath.section][:rows][indexPath.row]
    
    unless cell_data[:action].nil? || cell_data[:disabled] == true
      if self.respond_to?(cell_data[:action])
        if !cell_data[:action_param].nil?
          self.send(cell_data[:action], cell_data[:action_param])
        else
          self.send(cell_data[:action])
        end
      end
    end
    
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  end
  
end