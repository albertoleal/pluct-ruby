module Pluct
  module Errors
    class PluctErrors < StandardError
      attr_accessor :message

      def initialize(message)
        @message = message
        super
      end
    end
  end
end
