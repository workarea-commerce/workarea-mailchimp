require 'workarea/mail_chimp/tasks/ecommerce'

namespace :workarea do
  namespace :mail_chimp do
    desc 'Seed MailChimp data'
    task install: :environment do
      Rake::Task['workarea:mail_chimp:seed_store'].execute
      Rake::Task['workarea:mail_chimp:seed_products'].execute
      Rake::Task['workarea:mail_chimp:seed_orders'].execute
    end

    desc 'Create Default Store for MailChimp Ecommerce'
    task seed_store: :environment do
      puts 'Creating Store ...'
      Workarea::MailChimp::Tasks::Ecommerce.create_store
    end

    desc 'Export full products to MailChimp'
    task seed_products: :environment do
      puts 'Creating Products...'
      raise RuntimeError.new("No Store ID set in configuration!") unless Workarea::MailChimp.config.default_store[:id].present?

      Workarea::Catalog::Product.purchasable.each do |product|
        next if product.variants.empty?

        mc_product = Workarea::MailChimp::Product.new(product)

        request = Workarea::MailChimp.request
        store_id = Workarea::MailChimp.config.default_store[:id]

        if product.exported_to_mail_chimp_at.present?
          puts "Updating #{product.name}"
          request.ecommerce.stores(store_id).products(product.id.to_s).update(body: mc_product.to_h)
        else
          puts "Creating #{product.name}"
          request.ecommerce.stores(store_id).products.create(body: mc_product.to_h)

          product.update_attributes!(exported_to_mail_chimp_at: Time.current)
        end
      end
    end

    desc 'Export full orders to MailChimp'
    task seed_orders: :environment do
      puts 'Creating Orders...'
      raise RuntimeError.new("No Store ID set in configuration!") unless Workarea::MailChimp.config.default_store[:id].present?

      # turn on the syncing feature of MC - this will stop users from getting unwanted emails
      puts "Enable store sync"
      Workarea::MailChimp::Store.with_syncing_enabled do

        Workarea::Order.placed.each do |order|

          request = Workarea::MailChimp.request
          store_id = Workarea::MailChimp.config.default_store[:id]
          mc_order = Workarea::MailChimp::Order.new(order)

          if order.exported_to_mail_chimp_at.present?
            puts "Updating #{order.id}"
            request.ecommerce.stores(store_id).orders(order.id.to_s).update(body: mc_order.to_h)
          else
            puts "Creating #{order.id}"
            request.ecommerce.stores(store_id).orders.create(body: mc_order.to_h)

            order.update_attributes!(exported_to_mail_chimp_at: Time.current)
          end
        end
      end
    end
  end
end
