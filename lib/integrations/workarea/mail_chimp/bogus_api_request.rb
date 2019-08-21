module Workarea
  module MailChimp
    class BogusAPIRequest

      def initialize(builder: nil)
        @request_builder = builder
      end

      def post(params: nil, headers: nil, body: nil)
        Gibbon::Response.new(headers: {}, body: {})
      end

      def patch(params: nil, headers: nil, body: nil)
        Gibbon::Response.new(headers: {}, body: {})
      end

      def put(params: nil, headers: nil, body: nil)
        Gibbon::Response.new(headers: {}, body: {})
      end

      def get(params: nil, headers: nil)
        Gibbon::Response.new(headers: {}, body: {})
      end

      def delete(params: nil, headers: nil)
        Gibbon::Response.new(headers: {}, body: {})
      end
    end
  end
end
