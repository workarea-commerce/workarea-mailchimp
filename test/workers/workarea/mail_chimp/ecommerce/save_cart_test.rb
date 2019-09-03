require 'test_helper'

module Workarea
  class MailChimp::Ecommerce::SaveCartTest < TestCase
    def test_cart_mail_chimp_exported_timestamp
      order = create_placed_order
      order.placed_at = nil
      order.save!

      Workarea::MailChimp::Ecommerce::SaveCart.new.perform(order.id)

      order.reload

      assert(order.cart_exported_to_mail_chimp_at.present?)
    end

    def test_cart_not_exported_on_placed_orders
      order = create_placed_order

      Workarea::MailChimp::Ecommerce::SaveCart.new.perform(order.id)

      order.reload

      refute(order.cart_exported_to_mail_chimp_at.present?)
    end
  end
end
