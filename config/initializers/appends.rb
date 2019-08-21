module Workarea
  Plugin.append_partials(
    "storefront.edit_account_details",
    "workarea/storefront/users/accounts/edit"
  )

  Plugin.append_partials(
    "storefront.show_account_details",
    "workarea/storefront/users/accounts/email_interests"
  )

  Plugin.append_javascripts(
    'storefront.modules',
    'workarea/storefront/mail_chimp/mail_chimp_tracking'
  )

  Plugin.append_partials(
    'storefront.javascript',
    'workarea/storefront/mail_chimp/ecommerce_javascript'
  )
end
