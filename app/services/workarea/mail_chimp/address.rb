module Workarea
  module MailChimp
    class Address
      attr_reader :address, :options

      def initialize(address, options = {})
        @address = address
        @options = options
      end

      # @return Hash
      def to_h
        {
          name: address.first_name + " " + address.last_name,
          address1: address.street,
          address2: address.street_2.to_s,
          city: address.city,
          province: address.region.to_s,
          postal_code: address.postal_code.to_s,
          country: address.country.alpha2,
          phone: address.phone_number.to_s,
          company: address.company.to_s
        }
      end
    end
  end
end
