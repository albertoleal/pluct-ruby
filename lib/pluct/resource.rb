module Pluct
  class Resource
    include Pluct::Helpers::Request

    def initialize(url, auth=nil)
      @url = url
      @auth = auth
      @data = data
      Resource.create_methods(links)
    end

    #TODO: Authenticate the request if necessary.
    def data
      get @url
    end
    
    def schema(url=true)
      content_type = @data.headers[:content_type]
      return nil unless content_type 
      
      schema = content_type.match('.*profile=([^;]+);?')
      return nil unless schema

      schema_url = schema[1]

      url ? schema_url : ::MultiJson.decode(get(schema_url))
    end

    private
    def links
      schema(false).links
    end

    def self.create_methods(links=[])
      links.each do |link|
        define_method link.rel do |args|
          method = "GET" | link.method
          send(method.downcase, link.href, args)
        end 
      end
    end
  end
end
