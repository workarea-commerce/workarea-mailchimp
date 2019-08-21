require 'test_helper'

module Workarea
  module Storefront
    class MailChimpOrderTest < Workarea::IntegrationTest
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

      def create_place_mc_order
        attributes = {
          id: 'mc_1234',
          email: 'bcrouse-new@workarea.com',
          placed_at: Time.current
        }

        shipping_service = create_shipping_service

        order = Workarea::Order.new(attributes)
        order.add_item(product_id: 'mc_p_12345', sku: 'SKU1', quantity: 2)

        checkout = Workarea::Checkout.new(order)
        checkout.update(
          shipping_address: {
            first_name: 'Ben',
            last_name: 'Crouse',
            street: '22 S. 3rd St.',
            street_2: 'Second Floor',
            city: 'Philadelphia',
            region: 'PA',
            postal_code: '19106',
            country: 'US'
          },
          billing_address: {
            first_name: 'Ben',
            last_name: 'Crouse',
            street: '22 S. 3rd St.',
            street_2: 'Second Floor',
            city: 'Philadelphia',
            region: 'PA',
            postal_code: '19106',
            country: 'US'
          },
          shipping_service: shipping_service.name,
          payment: 'new_card',
          credit_card: {
            number: '1',
            month: '1',
            year: Time.current.year + 1,
            cvv: '999'
          }
        )

        unless checkout.place_order
          raise(
            UnplacedOrderError,
            'failed placing the order in the create_placed_order factory'
          )
        end

        order
      end

      def test_product_created_in_mailchimp
        Workarea.with_config do |config|
          config.mail_chimp.default_store = test_store_params

          VCR.use_cassette("mc_order_test", vcr_args) do
            Workarea::MailChimp.request.ecommerce.stores.create(body: test_store_params) rescue nil

            set_inventory
            set_product
            order = create_place_mc_order

            # check product was created
            mc_order = Workarea::MailChimp.request.ecommerce.stores(test_store_params[:id]).orders(order.id.to_s).retrieve
            assert_equal(order.id, mc_order.body["id"])

            # cleanup the order, proudct and store
            Workarea::MailChimp.request.ecommerce.stores(test_store_params[:id]).products(@product.id.to_s).delete
            Workarea::MailChimp.request.ecommerce.stores(test_store_params[:id]).orders(order.id.to_s).delete
            Workarea::MailChimp.request.ecommerce.stores(test_store_params[:id]).delete

          end
        end
      end
    end
  end
end
