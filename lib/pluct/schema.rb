module Pluct
  class Schema < OpenStruct
    include Pluct::Helpers::Request
    
    def initialize(path)
      @path = path
      @data = data
      @links = @data.links
    end
    
    private
    def data
      ::MultiJson.decode(get(@path))
    end
  end
end