require 'test_helper'
require 'workarea/mail_chimp/tasks/ecommerce'

module Workarea
  module MailChimp
    module Tasks
      class EcommerceTest < Workarea::TestCase
        include Workarea::MailChimpApiConfig

        setup :setup_mail_chimp_config
        teardown :reset_mail_chimp_config

        def test_create_store
          _response = VCR.use_cassette("mail_chimp/tasks/create_store-successful", vcr_args) do
            MailChimp::Tasks::Ecommerce.create_store
          end
        end

        private

        def setup_mail_chimp_config
          @_old_config = Workarea.config.mail_chimp

          Workarea.config.mail_chimp.default_store = {
            id: "qa_dummy_store_9",
            list_id: "fcd2925136",
            name: "QA dummy store 9",
            email_address: "jyucis@weblinc.com",
            domain: 'https://plugins-qa.demo.workarea.com',
            currency_code: "USD"
          }
        end

        def reset_mail_chimp_config
          Workarea.config.mail_chimp = @_old_config
        end
      end
    end
  end
end
