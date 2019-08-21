require 'test_helper'

module Workarea
  module Storefront
    class MailChimpSiteJavascriptTest < Workarea::IntegrationTest
      def test_connected_site_javascript
        Workarea.with_config do |config|
          config.mail_chimp.default_store = {
            id: "qa_dummy_store_9",
            list_id: "dd8f83a09e",
            name: "QA dummy store 4",
            email_address: "jyucis@weblinc.com",
            domain: 'https://plugins-qa.demo.workarea.com/',
            currency_code: "USD"
          }
          store = create_mail_chimp_store.reload

          get storefront.root_path

          assert_includes response.body, store.site_script_fragment
        end
      end
    end
  end
end
