require "test_helper"

module Workarea
  class MailChimp::SubscriptionTest < Workarea::IntegrationTest
    def test_unsubscribe
      set_current_user(
        create_user(email: "bcrouse@workarea.com", password: "w3bl1nc", email_signup: true)
      )

      patch storefront.users_account_path, params: { email_signup: false }
      refute(Email.signed_up?("bcrouse@workarea.com"))
    end
  end
end
