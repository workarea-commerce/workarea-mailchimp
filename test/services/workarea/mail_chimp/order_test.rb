require 'test_helper'

module Workarea
  module MailChimp
    class OrderTest < Workarea::TestCase
      def test_to_h
        order = create_placed_order
        hsh = Order.new(order).to_h

        assert_equal(order.id, hsh[:id])
        assert_equal("USD", hsh[:currency_code])
        assert_equal("11.00", hsh[:order_total])
        assert_equal("1.00", hsh[:shipping_total])
        assert_equal(1, hsh[:lines].size)
        assert_equal(2, hsh[:lines].first[:quantity])
        assert_equal("SKU", hsh[:lines].first[:product_variant_id])
        assert_equal(expected_address_hash, hsh[:shipping_address])
        assert_equal(expected_address_hash, hsh[:billing_address])
        assert_equal(expected_customer_hash, hsh[:customer])
      end

      private
        def expected_address_hash
          {
            name:"Ben Crouse",
            address1:"22 S. 3rd St.",
            address2:"Second Floor",
            city:"Philadelphia",
            province:"PA",
            postal_code:"19106",
            country:"US",
            phone:"",
            company:""
          }
        end

        def expected_customer_hash
          {
            id: Digest::MD5.hexdigest("bcrouse-new@workarea.com"),
            email_address: "bcrouse-new@workarea.com",
            opt_in_status: false,
            orders_count: 1,
            total_spent: "11.00",
            first_name: "Ben",
            last_name: "Crouse"
          }
        end
    end
  end
end
