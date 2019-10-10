module Workarea
  module MailChimpApiConfig
    def self.included(test)
      super
      test.setup :set_key
      test.teardown :reset_key
    end

    def set_key
      Rails.application.secrets.mail_chimp = { api_key: 'c89583c2b238d7aaa6df3e4307bb68c1-us16' }
    end

    def reset_key
      Rails.application.secrets.delete(:mail_chimp)
    end

    def vcr_args
      @vcr_args ||= { record: :once, match_requests_on: [:method, :uri] }
    end

    private

      def test_store_params
        {
          id: "test_store_1",
          list_id: "fcd2925136",
          name: "test_store_1",
          email_address: "jyucis@weblinc.com",
          currency_code: "USD"
        }
      end
  end
end
