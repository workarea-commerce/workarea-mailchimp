require 'test_helper'

module Workarea
  class MailChimp::Ecommerce::SaveProductTest < TestCase

    def test_product_mail_chimp_exported_timestamp
      product = create_product
      Workarea::MailChimp::Ecommerce::SaveProduct.new.perform(product.id)

      product.reload

      assert(product.exported_to_mail_chimp_at.present?)
    end
  end
end
