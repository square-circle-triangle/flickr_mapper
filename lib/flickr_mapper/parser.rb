module FlickrMapper
  class Parser
    class Failure < StandardError; end
    def parse
      raise "abstract parse method called"
    end
  end

  class HpricotParser < Parser
    def self.parse(data)
      response = Hpricot.XML(data)
      raise Parser::Failure, response.at(:err)['msg'] unless response.search(:err).empty?
      response
    end
  end
  
end