require 'test_helper'

module Workarea
  module Storefront
    class MailChimpProductTest < Workarea::IntegrationTest
      include Workarea::MailChimpApiConfig

      def set_inventory
        @inventory = create_inventory(
          id: 'SKU1',
          policy: 'standard',
          available: 2
        )
      end

      def set_product
        @product = create_product(
          name: 'MC Integration Product',
          id: 'mc_p_12345',
          variants: [
            { sku: 'SKU1', regular: 5.to_m },
            { sku: 'SKU2', regular: 6.to_m }
          ]
        )
      end


      def test_product_created_in_mailchimp
        Workarea.with_config do |config|
          config.mail_chimp.default_store = test_store_params

          VCR.use_cassette("mc_product_test", vcr_args) do
            Workarea::MailChimp.request.ecommerce.stores.create(body: test_store_params) rescue nil

            set_inventory
            set_product

            # check product was created
            mc_product = Workarea::MailChimp.request.ecommerce.stores(test_store_params[:id]).products(@product.id.to_s).retrieve
            assert_equal(@product.id, mc_product.body["id"])

            # cleanup the order and product
            Workarea::MailChimp.request.ecommerce.stores(test_store_params[:id]).products(@product.id.to_s).delete
            Workarea::MailChimp.request.ecommerce.stores(test_store_params[:id]).delete

          end
        end
      end
    end
  end
end
