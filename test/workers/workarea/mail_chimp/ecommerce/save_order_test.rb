require 'test_helper'

module Workarea
  class MailChimp::Ecommerce::SaveOrderTest < TestCase

    def test_order_mail_chimp_exported_timestamp
      order = create_placed_order
      Workarea::MailChimp::Ecommerce::SaveOrder.new.perform(order.id)

      order.reload

      assert(order.exported_to_mail_chimp_at.present?)
    end
  end
end
