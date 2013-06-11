module Pluct
  class Schema
    include Pluct::Helpers::Request

    attr_reader :path, :data, :links
    
    def initialize(path)
      @path = path
      @data = get_content
      @links = @data.links
    end
    
    def to_s
      @path  
    end

    private
    def get_content
      ::MultiJson.decode(get(@path))
    end
  end
end
