require "test_helper"

module Workarea
  class MailChimp::TrackingParamsTest < Workarea::IntegrationTest
    setup :set_inventory
    setup :set_product

    def set_inventory
      @inventory = create_inventory(
        id: 'SKU1',
        policy: 'standard',
        available: 2
      )
    end

    def set_product
      @product = create_product(
        name: 'Integration Product',
        variants: [
          { sku: 'SKU1', regular: 5.to_m },
          { sku: 'SKU2', regular: 6.to_m }
        ]
      )
    end

    def order
      Order.first
    end

    def test_campaign_id_saved_on_add_to_cart
      campaign_id = 'campaign_id_1'

      cookies['mc_cid'] = campaign_id

      get storefront.root_path, params: { mc_cid: campaign_id }

      post storefront.cart_items_path,
        params: {
          product_id: @product.id,
          sku: @product.skus.first,
          quantity: 1
        }

      assert(response.ok?)

      order.reload
      assert_equal(campaign_id, order.mail_chimp_campaign_id)
    end
  end
end
