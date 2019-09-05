module Workarea
  module MailChimp
    class Gateway::Members < Gateway
      def initialize(default_list_id)
        @default_list_id = default_list_id
      end

      # Returns Hash or nil
      #
      def details(email)
        response ||= begin
          MailChimp.request.lists(@default_list_id).members(digest_email(email)).retrieve
          rescue ::Gibbon::MailChimpError => e
            response_error_handler(e)
          end

        extract_member_details(response)
      end

      def unsubscribe(email, options = {})
        begin
          MailChimp.request.lists(@default_list_id).members(digest_email(email)).update(body: { status: "unsubscribed" })
        rescue ::Gibbon::MailChimpError => e
          response_error_handler(e)
        end
      end

      def subscribe(subscribe_argument)
        return unless subscribe_argument[:email_address]
        begin
          MailChimp.request.lists(@default_list_id).members(digest_email(subscribe_argument[:email_address])).upsert(body: subscribe_argument.merge("status" => "subscribed"))
        rescue ::Gibbon::MailChimpError => e
          response_error_handler(e)
        end
      end

      private

        # Returns
        # * Hash of details for subscribed emails
        # * nil if email does not exist
        # * nil if email is unsubscribed
        #
        def extract_member_details(details)
          if details["error"].present?
            nil
          elsif details["status"] == "unsubscribed"
            nil
          else
            details
          end
        end

        def digest_email(email)
          md5 = Digest::MD5.new
          md5.update(email.downcase)
          md5.hexdigest
        end
    end
  end
end
