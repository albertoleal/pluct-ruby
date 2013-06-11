module Pluct
  class Resource < OpenStruct
    include Pluct::Helpers::Request

    def initialize(url, schema)
      @url = url
      @data = data
      @schema = schema
      Resource.create_methods(@schema.links) if @schema
    end

    #TODO: Authenticate the request if necessary.
    def data
      get @url
    end

    private
    def self.create_methods(links=[])
      links.each do |link|
        define_method link.rel do |*args|
          method = "GET" || link["method"]
          send(method.downcase, link.href, *args)
        end 
      end
    end
  end
end
