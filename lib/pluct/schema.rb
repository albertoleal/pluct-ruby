module Pluct
  class Schema
    include Pluct::Helpers::Request

    attr_reader :path, :data, :links
    
    def initialize(path)
      @path = path
      @data = get_content
      @links = @data["links"]
    end
    
    def to_s
      @path  
    end
    
    def self.from_header(header)
      return nil unless headers[:content_type] 

      schema = headers[:content_type].match('.*profile=([^;]+);?')
      return nil unless schema

      Schema.new(schema[1])
    end

    private
    def get_content
      ::MultiJson.decode(get(@path))
    end
  end
end
