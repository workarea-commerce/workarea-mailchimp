module Workarea
  module MailChimp
    class BogusRequest

      def initialize(*)
        @path_parts = []
      end

      def method_missing(method, *args)
        # To support underscores, we replace them with hyphens when calling the API
        @path_parts << method.to_s.gsub("_", "-").downcase
        @path_parts << args if args.length > 0
        @path_parts.flatten!

        self
      end

      def respond_to_missing?(method_name, include_private = false)
        true
      end

      def send(*args)
        if args.length == 0
          method_missing(:send, args)
        else
          __send__(*args)
        end
      end

      def path
        @path_parts.join('/')
      end

      def create(params: nil, headers: nil, body: nil)
        BogusAPIRequest.new(builder: self).post(params: params, headers: headers, body: body)
        reset
      end

      def update(params: nil, headers: nil, body: nil)
        BogusAPIRequest.new(builder: self).patch(params: params, headers: headers, body: body)
        reset
      end

      def upsert(params: nil, headers: nil, body: nil)
        BogusAPIRequest.new(builder: self).put(params: params, headers: headers, body: body)
        reset
      end

      def retrieve(params: nil, headers: nil)
        BogusAPIRequest.new(builder: self).get(params: params, headers: headers)
        reset
      end

      def delete(params: nil, headers: nil)
        BogusAPIRequest.new(builder: self).delete(params: params, headers: headers)
        reset
      end

      protected

      def reset
        @path_parts = []
      end

      class << self
        attr_accessor :api_key, :timeout, :open_timeout, :api_endpoint, :proxy, :faraday_adapter, :symbolize_keys, :debug, :logger

        def method_missing(sym, *args, &block)
          new.send(sym, *args, &block)
        end

        def respond_to_missing?(method_name, include_private = false)
          true
        end
      end
    end
  end
end
