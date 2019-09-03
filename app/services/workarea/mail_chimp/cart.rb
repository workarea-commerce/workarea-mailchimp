module Workarea
  module MailChimp
    class Cart
      include Workarea::I18n::DefaultUrlOptions
      include Storefront::Engine.routes.url_helpers

      attr_reader :order, :options

      def initialize(order, options = {})
        @order = order
        @options = options
      end

      # @return Hash
      def to_h
        cart_hsh = {
          id: order.id.to_s,
          currency_code: order.total_price.currency.iso_code,
          order_total: order.total_price.to_s,
          tax_total: order.tax_total.to_s,
          shipping_total: order.shipping_total.to_s,
          lines: lines,
          customer: customer,
          checkout_url: Storefront::Engine.routes.url_helpers.resume_cart_url(token: order.token, host: Workarea.config.host),
        }

        # Mailchimp api does not accept empty values for campaign ID
        # only merge in if the campaign ID is present
        cart_hsh.merge!(campaign_id: order.mail_chimp_campaign_id) if order.mail_chimp_campaign_id.present?

        cart_hsh
      end

      private

        def customer
          customer = { id: Digest::MD5.hexdigest(order.email) }
          if send_full_customer?
            customer.merge!(
              {
                email_address: order.email,
                opt_in_status: Workarea::Email.signed_up?(order.email),
                first_name: payment.address.first_name,
                last_name:  payment.address.last_name
              }
            )
          end

          customer
        end

        def payment
          @payment ||= Workarea::Payment.find(order.id)
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
          @payment ||= Workarea::Payment.find(order.id)
        end

        def send_full_customer?
          options[:send_full_customer]
        end
    end
  end
end
