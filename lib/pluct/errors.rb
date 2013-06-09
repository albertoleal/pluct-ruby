module Pluct
  module Errors
    class PluctErrors < StandardError
      attr_accessor :message

      def initialize(message)
        @message = message
        super
      end
    end

    class UrlNotFound  < PluctErrors; end;
    class Unauthorized < PluctErrors; end;
  end
end
