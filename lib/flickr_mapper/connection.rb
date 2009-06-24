module FlickrMapper
  
  class Connection
    API_BASE = "http://api.flickr.com/services/rest/"
    
    @@api_key = "098c9bad4cdd2f0f1b587cb4c44017f8"
    #cattr_accessor :api_key
    attr_accessor :user_id
    
    def initialize(user_id=nil) # 26327616@N00
      @user_id = user_id unless user_id.nil?
    end
    
    def call(api_method, params)
      raise "no api key has been set!" if @@api_key.nil?
      dispatch(build_query(api_method, params))
    end
    
    private
    
    def api_url
      url = "#{API_BASE}?api_key=#{@@api_key}"
      url << "&user_id=#{@user_id}" if @user_id
      url
    end
    
    def dispatch(query)
      response = open(query).read
      return response
    end
  
    def build_query(api_method, params={})      
      optstr = { :method => api_method }.merge(params).map { |key, value| "#{key}=#{value}" }.join("&")
      "#{api_url}&#{optstr}"
    end  
  end
  
end