$:.push File.expand_path("../lib", __FILE__)

require "workarea/mail_chimp/version"

Gem::Specification.new do |s|
  s.name        = "workarea-mail_chimp"
  s.version     = Workarea::MailChimp::VERSION
  s.authors     = ["Mark Platt", "Mike Dalton"]
  s.email       = ["mplatt@weblinc.com", "mdalton@weblinc.com"]
  s.homepage    = "http://www.workarea.com"
  s.summary     = "MailChimp plugin for the Workarea ecommerce platform"
  s.description = "Rails Engine for MailChimp integrations"

  s.files = `git ls-files`.split("\n")

  s.required_ruby_version = ">= 2.3.0"

  s.add_dependency "workarea", "~>3.x"
  s.add_dependency "gibbon", "~>3.0"
end
