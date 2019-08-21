require "test_helper"

module Workarea
  module MailChimp
    class Gateway::ListTest < Workarea::SystemTest
      include Workarea::MailChimpApiConfig

      setup :gateway

      def gateway
        @gateway ||= Workarea::MailChimp.gateway
      end

      def vcr_args
        @vcr_args ||= { record: :once, match_requests_on: [:method, :uri, :body] }
      end

      def user
        @user ||= Workarea::User.new(
          id: "1",
          first_name: "Michael",
          last_name: "Dalton",
          groups: []
        )
      end

      def test_interests_when_looking_up_all_interest_groups
        Workarea.with_config do |config|
          config.mail_chimp.default_list_id = 'fcd2925136'
          config.mail_chimp.email_interests_id = '443f5598e4'

          response = VCR.use_cassette("interest_categories_read", vcr_args) do
            @gateway.interests
          end

          # It behaves like a successful MailChimp API call
          assert(response)

          if response.is_a? Hash
            refute(response.key?("error"))
          end

          assert(response.first.is_a?(Workarea::MailChimp::Group))
        end
      end
    end
  end
end
