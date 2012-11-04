# -*- encoding: utf-8 -*-
require File.expand_path('../lib/validates_ip_format_of/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Ryan Lovelett"]
  gem.email         = ["ryan@lovelett.me"]
  gem.description   = %q{Rails plugin that provides a validates_ip_format_of method to ActiveRecord models. IPs are validated by regexp. IP validation. Validate IP.}
  gem.summary       = %q{Validate the format of a IP by regexp in Ruby on Rails.}
  gem.homepage      = "http://github.com/RLovelett/validates_ip_format_of"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "validates_ip_format_of"
  gem.require_paths = ["lib"]
  gem.version       = ValidatesIpFormatOf::VERSION

  gem.add_dependency "activerecord", "~> 3.0.8"

  gem.add_development_dependency "rake", "~> 0.9.2.2"
  gem.add_development_dependency "rspec", "~> 2.11.0"
  gem.add_development_dependency "faker", "~> 1.1.2"
  gem.add_development_dependency "guard-rspec", "~> 2.1.0"
  gem.add_development_dependency "rb-fsevent", "~> 0.9.1"
  gem.add_development_dependency "terminal-notifier-guard", "~> 1.5.3"
end
