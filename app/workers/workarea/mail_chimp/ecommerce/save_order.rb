module Workarea
  module MailChimp
    module Ecommerce
      class SaveOrder
        include Sidekiq::Worker
        include Sidekiq::CallbacksWorker

        sidekiq_options(
          enqueue_on: { Workarea::Order => [:place] },
          unique: :until_executing
        )

        def perform(id)
          order = Workarea::Order.find(id)
          mc_order = Workarea::MailChimp::Order.new(order)
          store_id = Workarea::MailChimp.config.default_store[:id]

          MailChimp.request.ecommerce.stores(store_id).orders.create(body: mc_order.to_h)

          order.set(exported_to_mail_chimp_at: Time.current)

          delete_cart(id, store_id)
        end

        def delete_cart(id, store_id)
          MailChimp.request.ecommerce.stores(store_id).carts(id).delete rescue nil
        end
      end
    end
  end
end
