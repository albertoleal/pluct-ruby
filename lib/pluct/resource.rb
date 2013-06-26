module Pluct
  class Resource 
    include Pluct::Helpers::Request

    attr_reader :url, :data, :schema

    def initialize(url, schema, data=nil)
      @url = url      
      @data = data
      @schema = schema
      Resource.create_methods(@schema.links) if @schema
    end

    def data
      @data ||= get_data
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
          href = link["href"]
            
            
          # request
          #edit({name: 'nath', description: 'hi'})
          
          # self
          #           {
          #           description: "mmmmmm"
          #           links: [...7]-
          #           resource_id: "a91ccc92d638499bbe1291f69c32dacd"
          #           _resource_uri: "http://localhost:8888/baas/apps/a91ccc92d638499bbe1291f69c32dacd"
          #           name: "joaaaa"
          #           }
          
          #merged
          # {
          #           description: "hi"
          #           _resource_uri: "http://localhost:8888/baas/apps/a91ccc92d638499bbe1291f69c32dacd"
          #           name: "nath"
          #           }
                    
          payload = query_string.dup
          if ['PATCH', 'PUT'].include? method
            query_string.merge!(JSON.parse(self.data)) 
          end
          
          # payload: {:context_name=>"baas", :collection_name=>"apps"}
          # query_string: {:context_name=>"baas", :collection_name=>"apps"}
          
          uri = define_request_uri(href, query_string)
          payload = define_request_payload(href, uri, payload)          
          options.unshift(payload)
          
          #query_string (uri_template), payload, headers
          response = send(method.downcase, uri, *options)
          uri = response.headers[:location] if response.headers[:location]

          Pluct.get_resource uri
        end 
      end
    end
    
    def define_request_uri(uri_template, query_string)
      template = Addressable::Template.new(uri_template)
      Addressable::URI.parse(template.expand(query_string)).to_s      
    end
    
    def define_request_payload(uri_template, href, payload)
      template = Addressable::Template.new(uri_template)
      uri_template = template.extract(href)
      
      payload.delete_if{ |key, value| uri_template.include?(key) }
    end
  end
end