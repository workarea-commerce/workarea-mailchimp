module Workarea
  module MailChimp
    class Product
      include ActionView::Helpers::AssetUrlHelper
      include Core::Engine.routes.url_helpers
      include Storefront::Engine.routes.url_helpers
      include Workarea::ApplicationHelper

      attr_reader :product

      def initialize(product)
        @product = product
      end

      # @return Hash
      def to_h
        {
          id: product.id.to_s,
          title: product.name,
          handle: product.slug,
          url:  product_url(id: product.to_param, host: Workarea.config.host),
          description: product.description.to_s,
          image_url: primary_image,
          variants: variants
        }
      end

      private

        def variants
          @variants ||= product.variants.map{ |v| Variant.new(v).to_h }
        end

        def primary_image
          Workarea.config.host + ProductPrimaryImageUrl.new(product).path
        end

        def mounted_core
          self
        end
    end
  end
end
