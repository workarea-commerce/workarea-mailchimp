module Workarea
  module MailChimp
    class Variant
      include ActionView::Helpers::AssetUrlHelper
      include Core::Engine.routes.url_helpers
      include Workarea::ApplicationHelper

      delegate :sku, to: :variant

      attr_reader :variant

      def initialize(variant)
        @variant = variant
      end

      # @return Hash
      def to_h
        {
          id: sku,
          title: variant.name,
          sku: sku,
          price: price.to_s,
          inventory_quantity: inventory_sku.available_to_sell,
          visibility: inventory_sku.displayable?.to_s
        }
      end

      private

      def inventory_sku
        @inventory_sku ||= Inventory::Sku.find(sku) rescue Inventory::Sku.new(id: sku)
      end

      def pricing_sku
        @pricing_sku ||= Pricing::Sku.find(sku) rescue Pricing::Sku.new(id: sku)
      end

      def price
        pricing_sku.sell_price.dollars.to_f
      end
    end
  end
end
