Workarea.configure do |config|
  config.mail_chimp = ActiveSupport::Configurable::Configuration.new

  config.mail_chimp.default_list_id = ''
  config.mail_chimp.email_interests_id = ''

  config.mail_chimp.default_store = {
    id: "" ,
    list_id: "",
    name: "Ecommerce Store",
    email_address: "",
    currency_code: "USD"
  }
end
