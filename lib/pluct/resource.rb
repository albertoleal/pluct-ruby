module Pluct
  class Resource 
    include Pluct::Helpers::Request

    attr_reader :url, :data, :schema

    def initialize(url, schema, data=nil)
      @url = url
      @data = data || get_data
      @schema = schema
      Resource.create_methods(@schema.links) if @schema
    end

    #TODO: Authenticate the request if necessary.
    def get_data
      get @url
    end

    private
    def self.create_methods(links=[])
      links.each do |link|
        define_method link["rel"] do |*args|
          query_string, *options = *args
          method = link["method"] || "GET"
          
          if query_string
            href = Addressable::Template.new(link["href"])
            href = href.expand(query_string).to_s          
          end

          #query_string (uri_template), payload, headers
          response = send(method.downcase, link["href"], *options)

          self.new(link['href'], Schema.from_header(response.headers), response.body)  
        end 
      end
    end
  end
end
