require 'test_helper'

module Workarea
  module MailChimp
    class ProductTest < Workarea::TestCase
      def test_to_h
        product = create_product(id: "32F5411045")
        hsh = Product.new(product).to_h

        assert_equal(product.id, hsh[:id])
        assert_equal(product.name, hsh[:title])
        assert_equal(1, hsh[:variants].size)
        assert_equal(expected_variant_hash, hsh[:variants].first)
      end

      private
        def expected_variant_hash
          {
            id: "SKU",
            title: "SKU",
            sku: "SKU",
            price: "5.0",
            inventory_quantity: 99999,
            visibility: "true"
          }
        end
    end
  end
end
