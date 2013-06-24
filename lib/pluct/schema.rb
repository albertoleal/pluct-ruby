module Pluct
  class Schema
    include Pluct::Helpers::Request

    attr_reader :path, :data
    
    def initialize(path)
      @path = path
    end
    
    def data
      @data ||= ::MultiJson.decode(get(@path))
    end
    
    def links
      self.data["links"]
    end
    
    def to_s
      @path  
    end
    
    def self.from_header(headers)
      return nil unless headers[:content_type] 

      schema = headers[:content_type].match('.*profile=([^;]+);?')
      return nil unless schema

      Schema.new(schema[1])
    end
  end
end
