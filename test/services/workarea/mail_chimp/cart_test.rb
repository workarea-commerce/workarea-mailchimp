require 'test_helper'

module Workarea
  module MailChimp
    class CartTest < Workarea::TestCase
      def test_to_h
        order = create_placed_order
        hsh = Cart.new(order, send_full_customer: true).to_h

        assert_equal(order.id, hsh[:id])
        assert_equal("USD", hsh[:currency_code])
        assert_equal("11.00", hsh[:order_total])
        assert_equal("1.00", hsh[:shipping_total])
        assert_equal(1, hsh[:lines].size)
        assert_equal(2, hsh[:lines].first[:quantity])
        assert_equal("SKU", hsh[:lines].first[:product_variant_id])
        assert_equal(expected_new_customer_hash, hsh[:customer])

        assert_equal("http://www.example.com/cart/resume/#{order.token}", hsh[:checkout_url])

        hsh = Cart.new(order, send_full_customer: false).to_h
        assert_equal(expected_existing_customer_hash, hsh[:customer])
      end

      private

        def expected_new_customer_hash
          {
            id: Digest::MD5.hexdigest("bcrouse-new@workarea.com"),
            email_address: "bcrouse-new@workarea.com",
            opt_in_status: false,
            first_name: "Ben",
            last_name: "Crouse"
          }
        end

        def expected_existing_customer_hash
          {
            id: Digest::MD5.hexdigest("bcrouse-new@workarea.com")
          }
        end
    end
  end
end
