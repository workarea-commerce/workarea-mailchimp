module Workarea
  module MailChimp
    class Engine < ::Rails::Engine
      include Workarea::Plugin

      isolate_namespace Workarea::MailChimp

      %w(lib/integrations).each do |path|
        config.autoload_paths << "#{config.root}/#{path}"
        config.eager_load_paths << "#{config.root}/#{path}"
      end
    end
  end
end
