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
          method = link["method"] || "GET"
          send(method.downcase, link.href, *args)
        end 
      end
    end
  end
end
