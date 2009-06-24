module FlickrMapper

  class Base
    attr_accessor :connection
    
    def initialize(id=nil)
      @id = id unless id.nil?
      @connection = FlickrMapper::Connection.new() #user_id??
    end
    
    # This can definitely be done in a cleaner way
    def attributes
      attributes = {}
      self.instance_variables.each do |i| 
        meth = i.gsub("@","")
        attributes[meth.to_sym] = self.send meth
      end
      attributes
    end
    
    def self.find(method, params={})
      req = FlickrMapper::Connection.new #('2415296118')
      raw = HpricotParser.parse(req.call(method, params))
      self.parse(raw)
    end
    
    def request_raw(method, params={})
      req = FlickrMapper::Connection.new #('2415296118')
      HpricotParser.parse(req.call(method, params))
    end
    
  end
  
end