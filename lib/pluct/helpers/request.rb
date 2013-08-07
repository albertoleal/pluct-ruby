require 'rest_client'

module Pluct
  module Helpers
    module Request
      DEFAULT_HEADERS = {
        'content-type' => 'application/json'
      }

    protected

      def get(url, data = nil, headers = nil)
        headers = (headers ? DEFAULT_HEADERS.merge(headers) : DEFAULT_HEADERS)
        options = headers.dup
        options.merge!(params: data)
        RestClient.get(url, options)
      rescue RestClient::Exception => e
        raise_exception(url, e)
      end

      def head(url, *opts)
        options = Hash[opts] if opts
        resource = RestClient::Resource.new(url)
        options = (options ? DEFAULT_HEADERS.merge(options) : DEFAULT_HEADERS)
        resource.head(options)
      rescue RestClient::Exception => e
        raise_exception(url, e)
      end

      def delete(url, headers = nil)
        headers = (headers ? DEFAULT_HEADERS.merge(headers) : DEFAULT_HEADERS)
        RestClient.delete(url, headers)
      rescue RestClient::Exception => e
        raise_exception(url, e)
      end

      def post(url, *opts)
        data, options = *opts
        options = Hash[opts] if options
        resource = RestClient::Resource.new(url)
        options = (options ? DEFAULT_HEADERS.merge(options) : DEFAULT_HEADERS)
        resource.post(data.to_json, options)
      rescue RestClient::Exception => e
        raise_exception(url, e)
      end

      def put(url, *opts)
        data, options = *opts
        options = Hash[*opts] if options
        resource = RestClient::Resource.new(url)
        options = (options ? DEFAULT_HEADERS.merge(options) : DEFAULT_HEADERS)
        resource.put(data.to_json, options)
      rescue RestClient::Exception => e
        raise_exception(url, e)
      end

      def patch(url, *opts)
        data, options = *opts
        options = Hash[options] if options
        resource = RestClient::Resource.new(url)
        options = (options ? DEFAULT_HEADERS.merge(options) : DEFAULT_HEADERS)
        resource.patch(data.to_json, options)
      rescue RestClient::Exception => e
        raise_exception(url, e)
      end

      private
      def raise_exception(url, exception)
        case exception.http_code
          when 401
             raise Pluct::Errors::Unauthorized, {http_code: 401, error_description: "Url: #{url} - Exception Message: #{exception.message}"}
          when 404
             raise Pluct::Errors::UrlNotFound, {http_code: 404, error_description: "Url: #{url} - Exception Message: #{exception.message}"}
        end
      end
    end
  end
end
