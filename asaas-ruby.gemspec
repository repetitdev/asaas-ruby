# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'asaas/version'

Gem::Specification.new do |spec|
  spec.name          = "asaas-ruby"
  spec.version       = Asaas::VERSION
  spec.authors       = ["Roy"]
  spec.email         = ["eduardo.dev.java@gmail.com"]

  spec.summary       = %q{Asass.com Ruby API Wrapper}
  spec.description   = %q{Asass.com Ruby API Wrapper}
  spec.homepage      = "http://github.com/repetitdev/asaas-ruby"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", ">= 1.12"
  spec.add_development_dependency "rake", ">= 10.0"
  spec.add_development_dependency "rspec", ">= 3.2"
  spec.add_development_dependency "webmock", ">= 3.7.2"

  spec.add_dependency "activesupport", '>= 4.2'
  spec.add_dependency "hashie", '~> 5.0'
  spec.add_dependency "typhoeus", '>= 1.0'
  spec.add_dependency "rest-client", '>= 1.8'
  spec.add_dependency "awesome_print", '>= 1.6'
end
