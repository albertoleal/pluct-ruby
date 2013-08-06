module Pluct
  class Resource
    include Pluct::Helpers::Request

    attr_reader :data, :response, :schema, :uri

    def initialize(uri, response = nil)
      @uri = uri
      @response = response || get(@uri)
      @data ||= (JSON.is_json?(@response.body) ? JSON.parse(@response.body, {symbolize_names: true}) : {})

      @schema = Schema.from_header(@response.headers)
      Resource.create_methods(@schema.links) if @schema
    end

    def method_missing(method, *args)
      @data[method] || super
    end

  private

    def self.create_methods(links=[])
      links.each do |link|
        ldo = Pluct::LinkDescriptionObject.new(link)

        define_method link["rel"] do |*args|
          params, *options = *args

          method = link["method"] || "GET"

          if ['PATCH', 'PUT'].include? method
            params.merge!(@data)
          end

          uri = ldo.expand_href(params)
          payload = ldo.unused_mapping(params)
          options.unshift(payload)

          response = send(method.downcase, uri, *options)
          Resource.new(uri, response)
        end
      end
    end
  end
end
