require "workarea"
require "workarea/storefront"
require "workarea/admin"
require "gibbon"
require 'gibbon/request_decorator'

module Workarea
  module MailChimp
    def self.credentials
      (Rails.application.secrets.mail_chimp || {}).deep_symbolize_keys
    end

    def self.api_key
      credentials[:api_key]
    end

    def self.config
      Workarea.config.mail_chimp
    end

    def self.default_list_id
      Workarea.config[:default_list_id]
    end

    def self.list_prefrences_id
      Workarea.config[:default_list_id]
    end

    def self.config
      Workarea.config.mail_chimp
    end

    def self.current_store
      return unless config&.default_store && config.default_store[:id].present?

      Store.find_by(mail_chimp_id: config.default_store[:id]) rescue nil
    end

    def self.initialize_gateway
      if Rails.application.secrets.mail_chimp.present?
        secrets = Rails.application.secrets.mail_chimp.deep_symbolize_keys
        Workarea.config.gateways.mail_chimp = Workarea::MailChimp::Gateway.new(
          secrets[:default_list_id],
          secrets[:list_preferences_id]
        )
      else
        Workarea.config.gateways.mail_chimp = Workarea::MailChimp::BogusGateway.new
      end
    end

    def self.gateway
      if credentials.present?
        Workarea::MailChimp::Gateway.new
      else
        Workarea::MailChimp::BogusGateway.new
      end
    end

    # Returns a single use gibbon request object
    def self.request
      if Workarea::MailChimp.api_key.present?
        Gibbon::Request.new(api_key: Workarea::MailChimp.api_key)
      else
        Workarea::MailChimp::BogusRequest.new(api_key: 'test-us1')
      end
    end
  end
end

require "workarea/mail_chimp/version"
require "workarea/mail_chimp/errors"
require "workarea/mail_chimp/engine"
