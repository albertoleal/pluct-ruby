module Pluct
  class Resource 
    include Pluct::Helpers::Request

    attr_reader :url, :data, :schema

    def initialize(url, schema)
      @url = url
      @data = get_data
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
        define_method link.rel do |*args|
          query_string, *options = *args
          method = link["method"] || "GET"
          href = link["href"]
          
          if query_string
            href = Addressable::Template.new(href)
            href = href.expand(query_string).to_s          
          end

          #query_string (uri_template), payload, headers
          send(method.downcase, href, *options)
        end 
      end
    end
  end
end
