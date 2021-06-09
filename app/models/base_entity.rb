class BaseEntity

  attr_accessor :remote_id, :created_at, :updated_at

  def initialize(options = {})
    options.map{|k, v| self.send("#{k}=", v) if self.respond_to?("#{k}=")}
  end

  def update_attributes(options = {})
    options.map{|k, v| self.send("#{k}=", v) if self.respond_to?("#{k}=")}
  end
  
  def new_record?
    remote_id.nil?
  end
  
  def attributes
    methods.map{|m| m if respond_to?("#{m}=")}.compact
  end
  
  def to_h
    attributes.map{|k, v| "#{k}: #{send(k)}"}.join(", ")
  end

end