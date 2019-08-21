module Workarea
  module Factories
    module MailChimp
      Factories.add(self)

      DEFAULT_INTERESTS = {
        "0eec3f3c22" => "Local Events",
        "0ade920a8e" => "Restaurant News and Events"
      }

      def email_interest_hash
        { _id: "2df74daed4", name: "Email Interests", interests: { "b5358c7791" => "Specials and Promotions" } }
      end

      def email_interests_hash(interests = DEFAULT_INTERESTS)
        { _id: "2df74daed4", name: "Email Interests", interests: interests }
      end

      def email_all_interests_hash
        {
          _id: "443f5598e4",
          name: "Email Interests",
          interests: {
            "7ca6cc1d86" => "Specials and Promotions",
            "8911545594" => "Local Events",
            "542a7ec7bb" => "Restaurant News and Events",
            "6908d70674" => "Corporate Gifts and Awards"
          }
        }
      end

      def create_mail_chimp_store(overrides = {})
        attributes = {
          mail_chimp_id: "qa_dummy_store_9",
          list_id: "fcd2925136",
          name: "QA dummy store 9",
          currency_code: "USD",
          connected_site: {
            site_foreign_id: "qa_dummy_store_9",
            site_script: {
              url: "https://chimpstatic.com/mcjs-connected/js/users/c40efe870eb1bc94745f06b1b/e89d077f314d14abffa7a031b.js",
              fragment: "<script id=\"mcjs\">!function(c,h,i,m,p){m=c.createElement(h),p=c.getElementsByTagName(h)[0],m.async=1,m.src=i,p.parentNode.insertBefore(m,p)}(document,\"script\",\"https://chimpstatic.com/mcjs-connected/js/users/c40efe870eb1bc94745f06b1b/e89d077f314d14abffa7a031b.js\");</script>"
            }
          }
        }.merge overrides
        Workarea::MailChimp::Store.create attributes
      end
    end
  end
end
