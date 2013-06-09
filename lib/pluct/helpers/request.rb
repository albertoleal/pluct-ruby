require 'rest_client'

module Pluct
  module Helpers
    module Request

      DEFAULT_HEADERS = {
        'content-type' => 'application/json'
      }

      def get(url, options={})
        resource = RestClient::Resource.new(url)
        response = resource.get(DEFAULT_HEADERS.merge(options))
        response.body
      rescue RestClient::Exception => e
        raise_exception(e)
      end

      private
      def raise_exception(exception)
        case exception.http_code
          when 401
             raise Pluct::Errors::Unauthorized, {http_code: 401, error_description: exception.http_body} 
          when 404
             raise Pluct::Errors::UrlNotFound, {http_code: 404, error_description: exception.http_body} 
        end
      end
    end
  end
end
