module Workarea
  module MailChimp
    class BogusGateway
      delegate :interests, to: :list

      class BogusList
        def interests
          [
            Workarea::MailChimp::Group.new(
              _id: 9,
              name: "Email Interests",
              interests: {
                "7ca6cc1d86" => "Specials and Promotions",
                "8911545594" => "Local Events",
                "542a7ec7bb" => "Restaurant News and Events",
                "6908d70674" => "Corporate Gifts and Awards"
              }
            )
          ]
        end
      end

      @@supported_methods = Workarea::MailChimp::Gateway.public_instance_methods

      def list
        BogusList.new
      end

      def method_missing(method, *args)
        return true if @@supported_methods.include? method
        super
      end
    end
  end
end
