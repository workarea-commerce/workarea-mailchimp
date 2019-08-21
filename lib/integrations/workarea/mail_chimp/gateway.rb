module Workarea
  module MailChimp
    class Gateway
      class MailChimpSubscriptionError < StandardError; end

      attr_reader :default_list_id, :email_interests_id

      delegate :details, to: :members
      delegate :interests, to: :list

      def self.acceptable_failure_codes
        [
          232, # Email_NotExists
          220, # List_InvalidImport (banned user / invalid email)
          400, # Member exists and cannot be subscribed
          404, # User not found
          500  # Inexplicable intermittent MailChimp-side error
        ]
      end

      # Use this for new or current subscriptions
      #
      # email: String
      # new_email: String
      # user: User
      #
      def subscribe(email, options = {})
        members.subscribe(
          SubscribeArgumentBuilder.new(
            email,
            options,
            default_list_id,
            email_interests_id
          ).build
        )
      end

      # Unsubscribe email from default list. This does not delete the record in
      # MailChimp.
      #
      # email: String
      #
      def unsubscribe(email, options = {})
        members.unsubscribe(email)
      end

      def members
        @members ||= MailChimp::Gateway::Members.new(default_list_id)
      end

      def list
        @list ||=
          MailChimp::Gateway::List.new(
            default_list_id,
            email_interests_id
          )
      end

      private

        def acceptable_failure?(error)
          self.class.acceptable_failure_codes.include?(error.body["status"])
        end

        def response_error_handler(error)
          if !acceptable_failure?(error)
            raise MailChimpSubscriptionError, error.message
          end

          error_hash(error)
        end

        def error_hash(error)
          { "error" => error.message }
        end

        def default_list_id
          Workarea::MailChimp.config.default_list_id
        end

        def email_interests_id
          Workarea::MailChimp.config.email_interests_id
        end
    end
  end
end
