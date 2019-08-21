require 'test_helper'

module Workarea
  module Storefront
    class CampaignTrackingTest < Workarea::SystemTest

      def test_tracking_cookie
        visit storefront.root_path(mc_cid: 'kittens')

        assert(page.driver.browser.manage.cookie_named('mc_cid').present?)
      end
    end
  end
end
