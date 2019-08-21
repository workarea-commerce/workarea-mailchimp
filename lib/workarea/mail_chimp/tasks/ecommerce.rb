module Workarea
  module MailChimp
    module Tasks
      module Ecommerce
        extend self

        # Creates an ecommerce store in Mail Chimp
        def create_store
          raise RuntimeError.new("No list id defined in store configuration!") unless Workarea::MailChimp.config.default_store[:list_id].present?

          if Workarea::MailChimp::Store.where(mail_chimp_id: Workarea::MailChimp.config.default_store[:id]).exists?
            raise RuntimeError, "Mailchimp store with id #{Workarea::MailChimp.config.default_store[:id]} already exists"
          end

          request = Workarea::MailChimp.request
          begin
            response = request.ecommerce.stores.create(body: Workarea::MailChimp.config.default_store)
          rescue Gibbon::MailChimpError => error
            raise RuntimeError, error.detail
          end

          Workarea::MailChimp::Store.create!(
            mail_chimp_id: response.body["id"],
            list_id: response.body["list_id"],
            name: response.body["name"],
            currency_code: response.body["currency_code"],
            connected_site: response.body.dig("connected_site"),
          )

          connected_site_id = response.body.dig("connected_site", "site_foreign_id")

          Workarea::MailChimp
            .request
            .connected_sites
            .add_path_part(connected_site_id)
            .actions
            .send('verify-script-installation')
            .create
        end
      end
    end
  end
end
