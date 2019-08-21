module Workarea
  module MailChimp
    class Order
      attr_reader :order, :options

      def initialize(order, options = {})
        @order = order
        @options = options
      end

      # @return Hash
      def to_h
        order_hsh = {
          id: order.id.to_s,
          financial_status: financial_status,
          fulfillment_status: fulfillment_status,
          currency_code: order.total_price.currency.iso_code,
          order_total: order.total_price.to_s,
          tax_total: order.tax_total.to_s,
          shipping_total: order.shipping_total.to_s,
          processed_at_foreign: order.placed_at.strftime('%FT%T%:z'),
          shipping_address: shipping_address,
          billing_address: billing_address,
          lines: lines,
          customer: customer
        }
        order_hsh.merge!(campaign_id: order.mail_chimp_campaign_id) if order.mail_chimp_campaign_id.present?
        order_hsh
      end

      private

        def customer
          {
            id: Digest::MD5.hexdigest(order.email),
            email_address: order.email,
            opt_in_status: Workarea::Email.signed_up?(order.email),
            orders_count: user_order_count,
            total_spent: user_order_total.to_s,
            first_name: payment.address.first_name,
            last_name:  payment.address.last_name
          }
        end

        def user_order_count
          user_orders.count
        end

        def user_order_total
          user_orders.map(&:total_price).sum
        end

        def user_orders
          @user_orders ||= Workarea::Order.placed.where(email: order.email)
        end

        def shipping_address
          return unless shipping.present?

          MailChimp::Address.new(shipping.address).to_h
        end

        def billing_address
          MailChimp::Address.new(payment.address).to_h
        end

        def financial_status
          options[:financial_status] || ""
        end

        def fulfillment_status
          options[:fulfillment_status] || ""
        end

        # order items. Mailchimp refers to them as "lines"
        def lines
          order.items.map do |oi|
            {
              id: oi.id.to_s,
              product_id: oi.product_id,
              product_variant_id: oi.sku,
              quantity: oi.quantity,
              price: oi.total_price.to_s
            }
          end
        end

        def payment
          @payment ||=  Workarea::Payment.find(order.id)
        end

        def shipping
          @shipping ||= Workarea::Shipping.find_by_order(order.id)
        end
    end
  end
end
