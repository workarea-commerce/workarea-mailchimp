module Workarea
  module MailChimp
    module Ecommerce
      class SaveCart
        include Sidekiq::Worker

        def perform(id, options = {})
          order = Workarea::Order.find(id)

          return if order.placed?
          return if order.email.blank?

          store_id = Workarea::MailChimp.config.default_store[:id]

          customer_id = Digest::MD5.hexdigest(order.email)

          # see if customer exists already
          # existing customers only need to send the ID ot mailchimp
          customer = MailChimp.request.ecommerce.stores(store_id).customers(customer_id).retrieve rescue nil

          cart_options = { send_full_customer: customer.blank? }
          mc_cart = Workarea::MailChimp::Cart.new(order, cart_options)

          if order.cart_exported_to_mail_chimp_at.present?
            MailChimp.request.ecommerce.stores(store_id).carts(order.id.to_s).update(body: mc_cart.to_h)
          else
            MailChimp.request.ecommerce.stores(store_id).carts.create(body: mc_cart.to_h)
          end

          # cart lines in mail chimp need to be removed outside of the delete or update methods.
          if options["deleted_item_id"].present?
            MailChimp.request.ecommerce.stores(store_id).carts(order.id.to_s).lines(options["deleted_item_id"]).delete
          end

          order.set(cart_exported_to_mail_chimp_at: Time.current)
        end
      end
    end
  end
end
