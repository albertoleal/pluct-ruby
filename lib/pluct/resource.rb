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
        define_method link["rel"] do |*args|
          query_string, *options = *args
          method = link["method"] || "GET"
          href = link["href"]

          payload = query_string.dup
          if ['PATCH', 'PUT'].include? method
            query_string.merge!(@data)
          end

          uri = define_request_uri(href, query_string)
          payload = define_request_payload(href, uri, payload)
          options.unshift(payload)

          response = send(method.downcase, uri, *options)
          Resource.new(uri, response)
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
