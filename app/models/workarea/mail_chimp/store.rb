module Workarea
  module MailChimp
    class Store
      include ApplicationDocument

      field :mail_chimp_id, type: String
      field :list_id, type: String
      field :name, type: String
      field :currency_code, type: String
      field :connected_site, type: Hash

      index mail_chimp_id: 1

      def self.with_syncing_enabled(&block)
        MailChimp.request.ecommerce.stores(Workarea::MailChimp.config.default_store[:id]).update(body: { is_syncing: true })
        block.call
      ensure
        MailChimp.request.ecommerce.stores(Workarea::MailChimp.config.default_store[:id]).update(body: { is_syncing: false })
      end

      def site_script_fragment
        connected_site.dig("site_script", "fragment")
      end
    end
  end
end
