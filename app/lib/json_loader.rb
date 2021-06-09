module JsonLoader

  def loadFromJson
    path = "#{json_object_type}/#{json_file_name}"
    file_path = NSBundle.mainBundle.pathForResource(path, ofType:"json")
    
    begin
      data = NSData.dataWithContentsOfFile(file_path, options:NSDataReadingMappedIfSafe, error:nil)
      opts = NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments
      json = NSJSONSerialization.JSONObjectWithData(data, options:opts, error:nil)
      self.settings = json
      !json.nil?
    rescue
      false
    end
  end
  
  def delayed_load_from_json
    false
  end  

end