module SearchDelegate
  
  def searchBarTextDidBeginEditing(searchBar)
    searchActive = false
    searchBar.setShowsCancelButton(true, animated: true)
  end

  def searchBarTextDidEndEditing(searchBar)
    searchActive = false
    searchBar.resignFirstResponder
    searchBar.setShowsCancelButton(false, animated: true)
  end

  def searchBarCancelButtonClicked(searchBar)
    searchActive = false
    searchBar.resignFirstResponder
  end

  def searchBarSearchButtonClicked(searchBar)
    searchBar.resignFirstResponder
  end

  def searchBar(searchBar, textDidChange: searchText)
    self.query = searchText
    
    NSObject.cancelPreviousPerformRequestsWithTarget(self, selector: "performSearch", object: nil)
    self.performSelector("performSearch", withObject: nil, afterDelay: 0.5)
  end
  
  def performSearch
  end
  
end