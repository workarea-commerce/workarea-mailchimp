module Workarea
  module MailChimp
    module Ecommerce
      class SaveProduct
        include Sidekiq::Worker
        include Sidekiq::CallbacksWorker

        sidekiq_options(
          enqueue_on: { Catalog::Product => [:save] },
          unique: :until_executing
        )

        def perform(id)
          product = Workarea::Catalog::Product.find(id)

          mc_product = Workarea::MailChimp::Product.new(product)

          store_id = Workarea::MailChimp.config.default_store[:id]

          if product.exported_to_mail_chimp_at.present?
            MailChimp.request.ecommerce.stores(store_id).products(product.id.to_s).update(body: mc_product.to_h)
          else
            MailChimp.request.ecommerce.stores(store_id).products.create(body: mc_product.to_h)
          end

          product.set(exported_to_mail_chimp_at: Time.current)
        end
      end
    end
  end
end
