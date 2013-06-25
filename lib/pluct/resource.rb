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
          href = link["href"]
          
          payload = query_string.dup
          query_string.merge!(JSON.parse(@data))

          template = Addressable::Template.new(href)
          uri = Addressable::URI.parse(template.expand(query_string).to_s)
          uri_template = template.extract(uri)
          
          payload.delete_if{|key, value| uri_template.include?(key.to_s)}
          options.unshift(payload)

          #query_string (uri_template), payload, headers
          response = send(method.downcase, uri.to_s, *options)
          uri = response.headers[:location] if response.headers[:location]

          #Resource.new(href, Schema.from_header(response.headers), response.body)            
          Pluct.get_resource(uri.to_s)
        end 
      end
    end
  end
end